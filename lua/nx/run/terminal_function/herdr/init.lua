local find_workspace_root = require("nx.utils.find_workspace_root")
local nx_options          = require("nx").options
local fn                  = vim.fn

-- This handles the final herdr pane run asynchronously via jobstart
local function run_full_herdr_command(cmds)
  for _, tmux_cmd in ipairs(cmds) do
    fn.jobstart(tmux_cmd, { detach = true, stdout_buffered = false })
  end
end

return function(final_cmd, keyword, node_version, split, debug)
  local workspace_root = find_workspace_root()
  local direction = split == "Vertical Split" and "right" or "down"
  local split_size = split == "Vertical Split"
      and nx_options.split_sizes.vertical
      or nx_options.split_sizes.horizontal

  -- convert to float. resizing parent pane.
  split_size = 100 - split_size
  split_size = split_size / 100

  local script_steps = {}

  if node_version then
    table.insert(script_steps, string.format("nvm use %s", node_version))
  end

  table.insert(script_steps, 'clear')
  table.insert(script_steps, final_cmd)

  local keystroke_injection = table.concat(script_steps, "; ") .. "\n"

  local split_size_arg = tostring(split_size)

  local split_cmd = string.format('herdr pane split --current --direction %s --cwd %q --ratio %s',
    direction,
    workspace_root,
    split_size_arg
  )

  local json_output = fn.system(split_cmd)
  local decoded_output = vim.fn.json_decode(json_output)

  local pane_id = decoded_output.result.pane.pane_id

  if pane_id and pane_id ~= "" then
    split_size = tostring(split_size / 100)

    local rename_cmd = string.format('herdr pane rename %s %q', pane_id, keyword)
    local run_cmd = string.format("herdr pane run %s '%s'", pane_id, keystroke_injection)

    run_full_herdr_command({ rename_cmd, run_cmd })
  end
end
