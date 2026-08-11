local get_options      = require("nx.run.get_options")
local last_command     = require("nx").last_command
local command_history  = require("nx").command_history
local run_with_command = require("nx.run.terminal_function.tmux.run_with_command")

return function(cmd, keyword, node_version, split, debug)
  if keyword == 'test' then
    get_options(function(options)
      local test_cmd = cmd

      if options and #options > 0 then
        test_cmd = test_cmd .. " " .. table.concat(options, " ")
      end
      -- Update last_command with the full command including options
      last_command.cmd = test_cmd
      command_history[#command_history + 1] = { cmd = test_cmd, node_version = node_version, split = split }
      run_with_command(test_cmd, node_version, split, debug)
    end)
    return
  end

  -- Update last_command with the full command
  last_command.cmd = cmd
  command_history[#command_history + 1] = { cmd = cmd, node_version = node_version, split = split }
  run_with_command(cmd, node_version, split, debug)
end
