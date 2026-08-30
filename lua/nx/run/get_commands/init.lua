local find_workspace_root = require("nx.utils.find_workspace_root")
local find_project_root = require("nx.utils.find_project_root")
local collect_targets = require("nx.utils.collect_targets")
local target_list_cache = require("nx").target_list

local popup = require("nx.popup.fzf_lua_popup")

return function(opts, callback)
  local workspace_root = find_workspace_root()
  local lines = {}
  local run_local_project = opts.run_local or false


  if target_list_cache and #target_list_cache > 0 then
    for _, target in ipairs(target_list_cache) do
      lines[#lines + 1] = target.command
    end
  end

  local handle = popup({
    items = lines,
    prompt = 'Select command> ',
    winopts = {
      title = opts.run_local and ' Project Commands ' or ' All Commands ',
    },
    filter = run_local_project and function()
      local open_file = vim.api.nvim_buf_get_name(0)
      local local_root = find_project_root(open_file)
      local include_all = (local_root == "." or local_root == "" or local_root == workspace_root)
      local project_name = include_all and nil or vim.fs.basename(local_root)

      local out = {}
      for i = 1, #target_list_cache do
        local target = target_list_cache[i]
        if include_all or target.project == project_name then
          out[#out + 1] = target.command
        end
      end

      return out
    end,
    keybinds = {
      {
        key = "Enter",
        desc = 'Select',
        fn = function(selected)
          if selected[1] then
            callback(selected[1])
          end
        end
      },
    },
  })

  if not (target_list_cache and #target_list_cache > 0) then
    collect_targets(workspace_root, function(targets)
      target_list_cache = targets or {}
      local new_lines = {}

      for _, target in ipairs(target_list_cache) do
        new_lines[#new_lines + 1] = target.command
      end

      if handle and handle.update then
        handle.update(new_lines)
      end
    end)
  end

  return handle
end
