local tmux              = require("nx.run.terminal_function.tmux")
local terminal          = require("nx.run.terminal_function.terminal")
local herdr             = require("nx.run.terminal_function.herdr")
local get_split_options = require("nx.run.get_split_options")
local nx_options        = require("nx").options
local last_command      = require("nx").last_command

local function run_switch(cmd, run_options)
  -- Update last_command with keyword and node_version
  last_command.node_version = run_options.node_version
  last_command.split = run_options.split

  if nx_options.tmux.enabled == true then
    return tmux(cmd, run_options)
  elseif nx_options.herdr.enabled == true then
    return herdr(cmd, run_options)
  else
    return terminal(cmd, run_options)
  end
end

return function(cmd, run_options)
  print(vim.inspect(run_options))

  if run_options.layout_type == "window" then
    return run_switch(cmd, run_options)
  end

  return get_split_options(cmd, run_options, run_switch)
end
