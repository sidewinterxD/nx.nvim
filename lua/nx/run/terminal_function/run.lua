local tmux              = require("nx.run.terminal_function.tmux")
local terminal          = require("nx.run.terminal_function.terminal")
local get_split_options = require("nx.run.get_split_options")
local nx_options        = require("nx").options
local last_command      = require("nx").last_command

local function run_switch(cmd, keyword, node_version, split, debug)
  -- Update last_command with keyword and node_version
  last_command.node_version = node_version
  last_command.split = split

  if nx_options.tmux.enabled ~= true then
    terminal(cmd, keyword, node_version, split, debug)
  else
    tmux(cmd, keyword, node_version, split, debug)
  end
end

return function(cmd, keyword, node_version)
  return get_split_options(cmd, keyword, node_version, run_switch)
end
