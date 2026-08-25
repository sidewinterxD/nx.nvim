local find_workspace_root = require("nx.utils.find_workspace_root")
local collect_targets = require("nx.utils.collect_targets")

local popup = require("nx.popup.fzf_lua_popup")

return function(opts, callback)
  local run_local_project = opts.run_local or false

  local project_root = find_workspace_root()
  local items = collect_targets(project_root) or {}

  local lines = {}

  for _, target in ipairs(items) do
    lines[#lines + 1] = target.command
  end

  return popup({
    items = lines,
    prompt = 'Select NX command> ',
    keybinds = {
      -- On default action (Enter), run your function
      {
        key = "Enter",
        desc = 'Select',
        fn = function(selected)
          -- selected is a table of selected lines (usually just one)
          if selected[1] then
            callback(selected[1])
          end
        end
      },
    },
  })
end
