local popup = require("nx.popup.fzf_lua_popup")
local command_history = require("nx").command_history
local nx_options = require("nx").options

return function(callback)
  local labels = {}
  local lookup = {}

  for i, run_options in ipairs(command_history) do
    local raw_cmd = nx_options.tmux.enabled == true and run_options.cmd or run_options.full_cmd
    local cmd_name = raw_cmd:match("nx run ([^%s']+)") or "unknown"
    local node_version = run_options.node_version or "N/A"
    local split = run_options.split or "N/A"
    local label = string.format("%d. %s | Node version: %s | Split: %s", i, cmd_name, node_version, split)

    table.insert(labels, label)
    table.sort(labels)

    lookup[label] = run_options
    lookup[label].cmd = raw_cmd
  end

  return popup({
    items = labels,
    prompt = 'Select command> ',
    winopts = {
      title = ' NX Command History ',
    },
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          local item = selected[1] and lookup[selected[1]]
          if item then
            return callback(item.cmd, item)
          end
        end
      },
      {
        key = "ctrl-c",
        desc = "Close",
        fn = function() return true end
      }

    }
  })
end
