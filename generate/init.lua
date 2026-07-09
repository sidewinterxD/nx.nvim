local find_workspace_root = require("nx.utils.find_workspace_root")
local read_json = require("nx.utils.read_json")
local popup = require("nx.popup.fzf_lua_popup")

local sep = package.config:sub(1, 1)
return function()
  local workspace_root = find_workspace_root()

  local supported_generators = {
    'component',
    'component-story',
  }

  local config_path_entries = {
    workspace_root,
    "node_modules",
    "@nx",
    "react",
    "generators.json"
  }

  local lookup = {}
  local labels = {}

  local generators_path = sep .. table.concat(config_path_entries, sep)
  local generators_json = read_json(generators_path)

  if not generators_json then return nil end

  local generators = generators_json.generators or {}

  for key, generator in pairs(generators) do
    if vim.tbl_contains(supported_generators, key) then
      local description = generator.description or "No description"
      local label = string.format("%s - %s", key, description)
      local aliases = {}

      for _, alias in ipairs(generator.aliases or {}) do
        table.insert(aliases, alias)
      end

      table.insert(labels, label)

      lookup[label] = {
        key = key,
        label = label,
        aliases = aliases,
        description = generator.description or "No description",
      }
    end
  end

  popup({
    items = labels,
    prompt = 'Select generator> ',
    actions = {
      ["enter"] = function(selected)
        local item = selected[1] and lookup[selected[1]]
        print(vim.inspect(item))
        -- You can add code here to run the selected generator
      end,
    },
  })
end
