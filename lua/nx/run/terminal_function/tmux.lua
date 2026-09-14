local get_options      = require("nx.run.get_options")
local last_command     = require("nx").last_command
local command_history  = require("nx").command_history
local run_with_command = require("nx.run.terminal_function.tmux.run_with_command")

return function(cmd, run_options)
  if run_options.keyword == 'test' then
    get_options(function(options)
      if options and #options > 0 then
        cmd = cmd .. " " .. table.concat(options, " ")
        run_options.cmd = cmd
      end

      -- Update last_command with the full command including options
      last_command.cmd = cmd
      command_history[#command_history + 1] = run_options
      run_with_command(cmd, run_options)
    end)

    return
  end

  -- Update last_command with the full command
  last_command.cmd = cmd
  command_history[#command_history + 1] = run_options

  run_with_command(cmd, run_options)
end
