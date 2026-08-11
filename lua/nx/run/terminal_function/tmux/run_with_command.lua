local find_workspace_root   = require("nx.utils.find_workspace_root")
local run_full_tmux_command = require("nx.run.terminal_function.tmux.run_full_tmux_command")
local nx_options            = require("nx").options

return function(final_cmd, node_version, split, debug)
  local shell = nx_options.shell
  local workspace_root = find_workspace_root()
  local direction = split == "Vertical Split" and "-h" or "-v"
  local size = split == "Vertical Split"
      and nx_options.split_sizes.vertical
      or nx_options.split_sizes.horizontal

  if node_version then
    final_cmd = string.format("nvm use %s; %s", node_version, final_cmd)
  end

  local pane_cmd = shell == "fish"
      and string.format('fish -c %q', final_cmd)
      or final_cmd

  local split_cmd = string.format(
    "tmux split-window %s -l %d -P -F '#{pane_id}' -c %q %q",
    direction,
    size,
    workspace_root,
    pane_cmd
  ) .. (debug == true and " \\; set-option -p remain-on-exit failed" or " \\; set-option -p remain-on-exit off")

  run_full_tmux_command({ split_cmd })
end
