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
    horizontal = 20,
    vertical = 20,
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
      { "<leader>nxj", group = "Nx Jump" },
      { "<leader>nxt", group = "Nx Test" }
    })
  end

  -- Keymaps
  local keymaps = {
    { "n", "<leader>nxr",  "<cmd>NxRunRoot<CR>",              desc = "Select command from root project" },
    { "n", "<leader>nxR",  "<cmd>NxReRun<CR>",                desc = "Re-run last command" },
    { "n", "<leader>nxh",  "<cmd>NxRunOldCmd<CR>",            desc = "Run command from history" },
    { "n", "<leader>nxl",  "<cmd>NxRunLocal<CR>",             desc = "Select command from current project" },
    { "n", "<leader>nxW",  "<cmd>NxReset<CR>",                desc = "Reset workspace" },
    { "n", "<leader>nxjp", "<cmd>NxJumpProject<CR>",          desc = "Jump to project" },
    { "n", "<leader>nxjw", "<cmd>NxJumpWorkspace<CR>",        desc = "Jump to workspace" },
    { "n", "<leader>nxjn", "<cmd>NxJumpWorkspaceConfig<CR>",  desc = "Open nx.json" },
    { "n", "<leader>nxjl", "<cmd>NxJumpLocalProjectJson<CR>", desc = "Open local project file" },
    { "n", "<leader>nxjP", "<cmd>NxPickJumpProjectJson<CR>",  desc = "Pick project file" },
    { "n", "<leader>nxg",  "<cmd>NxShowGraph<CR>",            desc = "Show Graph" },
    { "n", "<leader>nxtp", "<cmd>NxTestProject<CR>",          desc = "Run tests in project" },
    { "n", "<leader>nxtf", "<cmd>NxTestFile<CR>",             desc = "Run tests in current file" },
    { "v", "<leader>nxts", "<cmd>NxTestSelected<CR>",         desc = "Run selected test pattern in a file" },
  }

  for _, km in ipairs(keymaps) do
    vim.keymap.set(km[1], km[2], km[3], { desc = km.desc, noremap = true, silent = true })
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
