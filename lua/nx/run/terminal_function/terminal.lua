local find_workspace_root = require("nx.utils.find_workspace_root")
local get_options = require("nx.run.get_options")
local last_command = require("nx").last_command
local command_history = require("nx").command_history
local nx_options = require("nx").options
local run_full_native_command = require("nx.run.terminal_function.native.run_full_native_command")
local shell = nx_options.shell or vim.o.shell


return function(cmd, run_options)
  local workspace_root = find_workspace_root()
  local full_cmd = cmd

  full_cmd = "cd " .. workspace_root .. " && " .. full_cmd

  -- if nvm is used, we have a node_version, prepend that to the command
  if run_options.node_version then
    full_cmd = shell .. " -c 'nvm use " .. run_options.node_version .. " && " .. cmd .. "'"
  end

  if run_options.keyword == 'test' then
    get_options(function(options)
      local test_cmd = full_cmd
      if options and #options > 0 then
        test_cmd = test_cmd .. " " .. table.concat(options, " ")
      end
      -- Update last_command with the full command including options
      last_command.full_cmd = test_cmd
      command_history[#command_history + 1] = {
        full_cmd = test_cmd,
        node_version = run_options.ode_version,
        split =
            run_options.split
      }
      run_full_native_command(test_cmd, run_options.split)
    end)
    return
  end

  -- Update last_command with the full command
  last_command.full_cmd = full_cmd
  command_history[#command_history + 1] = {
    full_cmd = full_cmd,
    node_version = run_options.node_version,
    split =
        run_options.split
  }
  run_full_native_command(full_cmd, run_options.split)
end
