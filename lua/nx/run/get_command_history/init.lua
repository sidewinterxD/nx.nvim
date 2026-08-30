local popup = require("nx.popup.fzf_lua_popup")
local command_history = require("nx").command_history
local nx_options = require("nx").options

return function(callback)
  local labels = {}
  local lookup = {}

  for i, cmd_info in ipairs(command_history) do
    local raw_cmd = nx_options.tmux.enabled == true and cmd_info.cmd or cmd_info.full_cmd
    local cmd_name = raw_cmd:match("nx run ([^%s']+)") or "unknown"
    local node_version = cmd_info.node_version or "N/A"
    local split = cmd_info.split or "N/A"
    local label = string.format("%d. %s | Node version: %s | Split: %s", i, cmd_name, node_version, split)

    table.insert(labels, label)
    table.sort(labels)

    lookup[#label + 1] = {
      cmd = raw_cmd,
      node_version = node_version,
      split = split
    }
  end

  return popup({
    items = labels,
    prompt = 'Select command from history> ',
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          local item = selected[1] and lookup[selected[1]]
          if item then
            return callback(item.cmd, item.node_version, item.split)
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
