local run_with_command = require "nx.run.terminal_function.tmux.run_with_command"
local nx_options = require("nx").options
local run_full_native_command = require("nx.run.terminal_function.native.run_full_native_command")

return function(cmd, run_options)
  if (nx_options.tmux.enabled ~= true) then
    run_full_native_command(cmd, run_options)
    return
  end
  run_with_command(cmd, run_options)
end
