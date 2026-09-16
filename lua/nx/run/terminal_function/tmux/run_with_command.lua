local find_workspace_root   = require("nx.utils.find_workspace_root")
local run_full_tmux_command = require("nx.run.terminal_function.tmux.run_full_tmux_command")
local nx_options            = require("nx").options

return function(final_cmd, run_options)
  local shell = nx_options.shell
  local workspace_root = find_workspace_root()

  local layout_type = run_options.layout_type
  local tmux_subcmd = "split-window"
  local layout_args = ""

  if layout_type == "pane" then
    local direction = run_options.split == "Vertical Split" and "-h" or "-v"
    local split_size = run_options.split == "Vertical Split"
        and nx_options.split_sizes.vertical
        or nx_options.split_sizes.horizontal

    local split_size_arg = tostring(split_size)
    if split_size_arg:sub(-1) ~= "%" then
      split_size_arg = split_size_arg .. "%"
    end

    layout_args = string.format("-d %s -f -l %q", direction, split_size_arg)
  else
    tmux_subcmd = "new-window"
    local window_name = string.format("%s:%s", run_options.project, run_options.keyword)
    layout_args = string.format("-d -n %q", window_name)
  end

  if run_options.node_version then
    final_cmd = string.format("nvm use %s; %s", run_options.node_version, final_cmd)
  end

  local pane_cmd = shell == "fish"
      and string.format('fish -c %q', final_cmd)
      or final_cmd

  local full_cmd = string.format(
        "tmux %s %s -P -F '#{pane_id}' -c %q %q",
        tmux_subcmd,
        layout_args,
        workspace_root,
        pane_cmd
      ) ..
      (run_options.debug == true and " \\; set-option -p remain-on-exit failed" or " \\; set-option -p remain-on-exit off")

  run_full_tmux_command({ full_cmd }, run_options)
end
