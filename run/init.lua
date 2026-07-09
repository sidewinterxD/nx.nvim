local get_commands = require("nx.run.get_commands")
local switch = require("nx.run.terminal_function.switch")

return function(opts)
  return get_commands(opts, switch)
end
