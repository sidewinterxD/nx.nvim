local get_command_history = require "nx.run.get_command_history"
local re_run = require "nx.run.re_run"

return function()
  get_command_history(re_run)
end
