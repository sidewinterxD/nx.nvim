-- Create user commands immediately when the plugin is loaded

pcall(vim.api.nvim_create_user_command, 'NxRunRoot', function()
  require('nx.run')({ run_local = false })
end, { desc = 'Select command from root project' })

pcall(vim.api.nvim_create_user_command, 'NxReRun', function()
  -- Safely require 'nx' only when the user actually runs the command
  local nx = require("nx")

  if (nx.last_command.cmd == nil or nx.last_command.full_cmd == nil)
      and nx.last_command.node_version == nil then
    vim.notify("No command to re-run", vim.log.levels.WARN)
    return
  end
  local cmd = nx.options.tmux.enabled ~= false and nx.last_command.cmd or nx.last_command.full_cmd
  local node_version = nx.last_command.node_version
  local split = nx.last_command.split

  require('nx.run.re_run')(cmd, node_version, split)
end, { desc = 'Re-run last command' })

pcall(vim.api.nvim_create_user_command, 'NxRunOldCmd', function()
  local nx = require("nx")
  if #nx.command_history == 0 then
    vim.notify("No commands history found", vim.log.levels.WARN)
    return
  end
  require('nx.run.re_run.re_run_old')()
end, { desc = 'Select from old commands' })

pcall(vim.api.nvim_create_user_command, 'NxRunLocal', function()
  require('nx.run')({ run_local = true })
end, { desc = 'Select command from current project' })

pcall(vim.api.nvim_create_user_command, 'NxReset', function()
  vim.cmd('!npx nx reset')
  vim.notify("Workspace reset", vim.log.levels.INFO)
end, { desc = 'Nx Reset workspace' })

pcall(vim.api.nvim_create_user_command, 'NxJumpProject', function()
  require('nx.workspace')()
end, { desc = 'Nx Jump to project' })

pcall(vim.api.nvim_create_user_command, 'NxJumpWorkspace', function()
  require('nx.workspace')({ root = true })
end, { desc = 'Nx Jump to Workspace' })

pcall(vim.api.nvim_create_user_command, "NxJumpWorkspaceConfig", function()
  require("nx.workspace.jump_to_file")({ root = true })
end, { desc = "Nx Open nx.json" })

pcall(vim.api.nvim_create_user_command, "NxJumpLocalProjectJson", function()
  require("nx.workspace.jump_to_file")({ current = true })
end, { desc = "Nx Open local project.json" })

pcall(vim.api.nvim_create_user_command, "NxPickJumpProjectJson", function()
  require("nx.workspace.jump_to_file")
end, { desc = "Nx Pick project.json" })

pcall(vim.api.nvim_create_user_command, 'NxGenerate', function()
  require('nx.generate')()
end, { desc = 'Nx Generate @nx/react' })
