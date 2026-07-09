local M = {}

-- Setup caches
M.file_cache = {}
M.stat_cache = {}
-- setup last command cache
M.last_command = {
  node_version = nil,
  cmd = nil,
  split = nil,
  full_cmd = nil
}
-- setup command history cache
M.command_history = {}

-- Default options
local default_options = {
  nvm = {
    enabled = false
  },
  tmux = {
    enabled = false,
  },
  split_sizes = {
    horizontal = 12,
    vertical = 50,
  },
  shell = vim.o.shell,
  skip_dirs = { "node_modules", "dist", "build", "out", ".git", ".vscode", "target", "vendor" },
}

function M.setup(opts)
  -- Merge user options with defaults
  M.options = vim.tbl_deep_extend("force", default_options, opts and opts.options or {})

  -- Register which-key group if available
  local ok, wk = pcall(require, "which-key")

  if ok then
    wk.add({
      { "<leader>nx",  group = "Nx" },
      { "<leader>nxg", group = "Nx Generate" }
    })
  end

  -- Keymaps
  local keymaps = {
    { "<leader>nxr",  "<cmd>NxRunRoot<CR>",   desc = "Select command from root project" },
    { "<leader>nxR",  "<cmd>NxReRun<CR>",     desc = "Re-run last command" },
    { "<leader>nxh",  "<cmd>NxRunOldCmd<CR>", desc = "Run command for history" },
    { "<leader>nxl",  "<cmd>NxRunLocal<CR>",  desc = "Select command from current project" },
    { "<leader>nxW",  "<cmd>NxReset<CR>",     desc = "Nx Reset workspace" },
    { "<leader>nxgr", "<cmd>NxGenerate<CR>",  desc = "Nx Generate @nx/react" },
  }

  for _, km in ipairs(keymaps) do
    vim.keymap.set("n", km[1], km[2], { desc = km.desc, noremap = true, silent = true })
  end

  return M
end

return M
