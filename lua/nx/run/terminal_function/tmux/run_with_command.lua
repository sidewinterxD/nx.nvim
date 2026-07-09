local find_workspace_root   = require("nx.utils.find_workspace_root")
local run_full_tmux_command = require("nx.run.terminal_function.tmux.run_full_tmux_command")
local nx_options            = require("nx").options

return function(final_cmd, node_version, split)
  local workspace_root = find_workspace_root()
  local size = nx_options.split_sizes.horizontal

  if split == "Vertical Split" then
    size = nx_options.split_sizes.vertical
  end

  local split_cmd = string.format("tmux split-window %s -l %d -P -F '#{pane_id}'",
    split == "Vertical Split" and "-h" or "-v", size)

  local pane_id = vim.fn.system(split_cmd):gsub("%s+", "")

  if pane_id == "" then
    return
  end

  local tmux_cmds = {
    string.format("tmux send-keys -t %s 'cd %s' C-m", pane_id, workspace_root),
    string.format("tmux send-keys -t %s '%s' C-m", pane_id, final_cmd),
    string.format("tmux send-keys -t %s 'test $status -eq 0 -o $status -eq 130; and exit' C-m", pane_id),
  }

  if node_version then
    table.insert(tmux_cmds, 1, string.format("tmux send-keys -t %s 'nvm use %s' C-m", pane_id, node_version))
  end

  run_full_tmux_command(tmux_cmds)
end
