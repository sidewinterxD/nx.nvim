local collect_targets = require "nx.utils.collect_targets"
local find_workspace_root = require "nx.utils.find_workspace_root"

local M = {}

-- Setup caches
M.file_cache = {}
M.target_list = {}
M.project_list = {}
M.last_command = {
  node_version = nil,
  cmd = nil,
  split = nil,
  full_cmd = nil
}
M.command_history = {}

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
}

M.options = vim.deepcopy(default_options)

function M.setup(opts)
  local workspace_root = find_workspace_root()

  if not workspace_root then
    return
  end

  local user_opts = opts or {}
  if opts and opts.options then
    user_opts = opts.options
  end

  M.options = vim.tbl_deep_extend("force", default_options, user_opts)

  local ok, wk = pcall(require, "which-key")
  if ok and wk.add then
    wk.add({
      { "<leader>nx",  group = "Nx" },
      { "<leader>nxj", group = "Nx Jump" }
    })
  end

  -- Keymaps
  local keymaps = {
    { "<leader>nxr",  "<cmd>NxRunRoot<CR>",              desc = "Select command from root project" },
    { "<leader>nxR",  "<cmd>NxReRun<CR>",                desc = "Re-run last command" },
    { "<leader>nxh",  "<cmd>NxRunOldCmd<CR>",            desc = "Run command for history" },
    { "<leader>nxl",  "<cmd>NxRunLocal<CR>",             desc = "Select command from current project" },
    { "<leader>nxW",  "<cmd>NxReset<CR>",                desc = "Reset workspace" },
    { "<leader>nxjp", "<cmd>NxJumpProject<CR>",          desc = "Jump to project" },
    { "<leader>nxjw", "<cmd>NxJumpWorkspace<CR>",        desc = "Jump to workspace" },
    { "<leader>nxjn", "<cmd>NxJumpWorkspaceConfig<CR>",  desc = "Open nx.json" },
    { "<leader>nxjl", "<cmd>NxJumpLocalProjectJson<CR>", desc = "Open local project file" },
    { "<leader>nxjP", "<cmd>NxPickJumpProjectJson<CR>",  desc = "Pick project file" },
    { "<leader>nxg",  "<cmd>NxShowGraph<CR>",            desc = "Show Graph" },
  }

  for _, km in ipairs(keymaps) do
    vim.keymap.set("n", km[1], km[2], { desc = km.desc, noremap = true, silent = true })
  end

  collect_targets(nil, function(targets, projects)
    if targets and #targets > 0 and projects and #projects > 0 then
      M.target_list = targets
      M.project_list = projects
      return
    end

    vim.notify("Nx: No targets found in workspace", vim.log.levels.WARN, { title = "Nx" })
  end)

  return M
end

return M
