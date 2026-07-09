local find_project_root = require("nx.utils.find_project_root")
local scan_for_project_json = require("nx.utils.scan_for_project_json")
local read_json = require("nx.utils.read_json")
local get_project_name = require("nx.utils.get_project_name")
local add_targets = require("nx.utils.add_targets")

return function(root)
  root = root or find_project_root()

  local items = {}
  local seen_projects = {}

  for _, pjpath in ipairs(scan_for_project_json(root) or {}) do
    local dec = read_json(pjpath)

    if dec and type(dec.targets) == "table" then
      local project_name = get_project_name(dec, pjpath)

      if not seen_projects[project_name] then
        seen_projects[project_name] = true
        add_targets(items, project_name, dec, pjpath)
      end
    end
  end

  return items
end
