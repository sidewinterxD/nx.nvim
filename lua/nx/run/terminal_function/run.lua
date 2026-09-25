local tmux         = require("nx.run.terminal_function.tmux")
local terminal     = require("nx.run.terminal_function.terminal")
local herdr        = require("nx.run.terminal_function.herdr")
local nx_options   = require("nx").options
local last_command = require("nx").last_command

local function run_switch(cmd, run_options)
  -- Update last_command with keyword and node_version
  last_command.node_version = run_options.node_version
  last_command.split = run_options.split
  last_command.layout_type = run_options.layout_type
  last_command.keyword = run_options.keyword
  last_command.project = run_options.project
  last_command.cmd = run_options.cmd
  last_command.args = run_options.args
  last_command.debug = run_options.debug

  if nx_options.tmux.enabled == true then
    return tmux(cmd, run_options)
  elseif nx_options.herdr.enabled == true then
    return herdr(cmd, run_options)
  else
    return terminal(cmd, run_options)
  end
end

return function(cmd, run_options)
  return run_switch(cmd, run_options)
end
