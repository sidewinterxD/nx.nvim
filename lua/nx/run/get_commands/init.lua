local build_lines = require("nx.utils.build_lines")
local find_project_root = require("nx.utils.find_project_root")
local find_workspace_root = require("nx.utils.find_workspace_root")
local collect_targets = require("nx.utils.collect_targets")
local target_list = require("nx").target_list

local popup = require("nx.popup.fzf_lua_popup")

return function(opts, callback)
  local run_local_project = opts.run_local or false
  -- local project_root = find_workspace_root()
  --
  -- if run_local_project then
  --   local local_file = vim.api.nvim_buf_get_name(0)
  --
  --   project_root = find_project_root(local_file)
  -- end
  --
  -- local items = collect_targets(project_root)
  --
  -- if not items or #items == 0 then
  --   vim.notify("nx: no targets or scripts found in " .. project_root, vim.log.levels.INFO)
  --   return
  -- end
  --
  -- local lines = build_lines(items)

  local lines = {}

  for _, item in ipairs(target_list) do
    lines[#lines + 1] = item.command
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
