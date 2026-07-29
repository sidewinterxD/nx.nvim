local find_workspace_root = require("nx.utils.find_workspace_root")
local read_json = require("nx.utils.read_json")
local scan_for_project_json = require("nx.utils.scan_for_project_json")

local popup = require("nx.popup.fzf_lua_popup")

return function(opts)
  local workspace_root = find_workspace_root()
  local options = opts or {}

  if options.root == true then
    vim.notify(workspace_root, vim.log.levels.INFO)
    return vim.cmd.cd(vim.fn.fnameescape(workspace_root))
  end

  local labels = {}
  local lookup = {}
  local project_files = scan_for_project_json(workspace_root) or {}

  for _, pjpath in ipairs(project_files) do
    local dec = read_json(pjpath)
    local project_name = (dec and dec.name) or "unknown"

    if not lookup[project_name] then
      labels[#labels + 1] = project_name
      lookup[project_name] = (pjpath:match("(.+)/project.json$") or workspace_root)
    end
  end

  if #labels == 0 then
    vim.notify("nx: no projects found in " .. workspace_root, vim.log.levels.INFO)
    return
  end

  return popup({
    items = labels,
    prompt = "Select NX Project> ",
    actions = {
      ["default"] = function(selected)
        local item = selected[1] and lookup[selected[1]]
        if item then
          vim.cmd.cd(vim.fn.fnameescape(item))
        end
      end,
    },
  })
end
