local M = {}

-- Setup caches
M.file_cache = {}
M.stat_cache = {}
M.last_command = {
  node_version = nil,
  cmd = nil,
  split = nil,
  full_cmd = nil
}
M.command_history = {}

-- Minimal startup cache for Nx projects + targets
M.projects = {}
M.target_list = {}

-- Default options
local default_options = {
  nvm = {
    enabled = false
  },
  tmux = {
    enabled = false,
  },
  herdr = {
    enabled = false,
  },
  split_sizes = {
    horizontal = 12,
    vertical = 50,
  },
  shell = vim.o.shell,
  skip_dirs = { "node_modules", "dist", "build", "out", ".git", ".vscode", "target", "vendor" },
}

M.options = vim.deepcopy(default_options)

local function preload_projects_and_targets(root)
  vim.system(
    { "./node_modules/.bin/nx", "graph", "--file=stdout" },
    { cwd = root, text = true },
    function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          vim.notify("nx graph failed: " .. (res.stderr or ""), vim.log.levels.WARN)
        end)
        return
      end

      local ok, decoded = pcall(vim.json.decode, res.stdout or "")
      if not ok then
        return
      end

      local nodes = (((decoded or {}).graph or {}).nodes) or {}
      local projects = {}
      local project_list = {}
      local target_list = {}

      for name, node in pairs(nodes) do
        local project_root = node.data and node.data.root
        local targets = {}

        for target_name, _ in pairs((node.data and node.data.targets) or {}) do
          targets[#targets + 1] = target_name
          target_list[#target_list + 1] = {
            project = name,
            target = target_name,
            command = name .. ":" .. target_name,
          }
        end

        table.sort(targets)

        projects[name] = {
          root = project_root,
          targets = targets,
        }

        project_list[#project_list + 1] = {
          name = name,
          root = project_root,
        }
      end

      table.sort(project_list, function(a, b) return a.name < b.name end)
      table.sort(target_list, function(a, b) return a.command < b.command end)

      M.projects = projects
      M.project_list = project_list
      M.target_list = target_list
    end
  )
end

function M.setup(opts)
  -- Safely extract user options even if passed via sub-tables or straight maps
  local user_opts = opts or {}
  if opts and opts.options then
    user_opts = opts.options
  end

  -- Merge user options directly into the main module options
  M.options = vim.tbl_deep_extend("force", default_options, user_opts)

  -- Register which-key group if available (Safely handles v3 spec)
  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>nx",  group = "Nx" },
      { "<leader>nxg", group = "Nx Generate" },
      { "<leader>nxj", group = "Nx Jump" }
    })
  end

  -- Keymaps
  local keymaps = {
    { "<leader>nxr",  "<cmd>NxRunRoot<CR>",              desc = "Select command from root project" },
    { "<leader>nxR",  "<cmd>NxReRun<CR>",                desc = "Re-run last command" },
    { "<leader>nxh",  "<cmd>NxRunOldCmd<CR>",            desc = "Run command for history" },
    { "<leader>nxl",  "<cmd>NxRunLocal<CR>",             desc = "Select command from current project" },
    { "<leader>nxW",  "<cmd>NxReset<CR>",                desc = "Nx Reset workspace" },
    { "<leader>nxgr", "<cmd>NxGenerate<CR>",             desc = "Nx Generate @nx/react" },
    { "<leader>nxjp", "<cmd>NxJumpProject<CR>",          desc = "Nx Jump to project" },
    { "<leader>nxjw", "<cmd>NxJumpWorkspace<CR>",        desc = "Nx Jump to workspace" },
    { "<leader>nxjn", "<cmd>NxJumpWorkspaceConfig<CR>",  desc = "Nx Open nx.json" },
    { "<leader>nxjl", "<cmd>NxJumpLocalProjectJson<CR>", desc = "Nx Open local project.json" },
    { "<leader>nxjP", "<cmd>NxPickJumpProjectJson<CR>",  desc = "Nx Pick project.json" },
  }

  for _, km in ipairs(keymaps) do
    vim.keymap.set("n", km[1], km[2], { desc = km.desc, noremap = true, silent = true })
  end

  -- Minimal async startup init
  preload_projects_and_targets(vim.fn.getcwd())

  return M
end

return M
