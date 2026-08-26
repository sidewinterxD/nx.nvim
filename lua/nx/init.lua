local collect_targets = require "nx.utils.collect_targets"
local M = {}

-- Setup caches
M.file_cache = {}
M.stat_cache = {}
M.target_list = {}
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
  skip_dirs = { "node_modules", "dist", "build", "out", ".git", ".vscode", "target", "vendor" },
}

M.options = vim.deepcopy(default_options)

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

  collect_targets(nil, function(targets)
    if targets and #targets > 0 then
      M.target_list = targets
      return
    end

    vim.notify("Nx: No targets found in workspace", vim.log.levels.WARN, { title = "Nx" })
  end)

  return M
end

return M
