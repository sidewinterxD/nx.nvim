local find_workspace_root = require("nx.utils.find_workspace_root")
local read_json = require("nx.utils.read_json")
local popup = require("nx.popup.fzf_lua_popup")

local sep = package.config:sub(1, 1)



return function(callback)
  local workspace_root = find_workspace_root()

  local config_path_entries = {
    workspace_root,
    "node_modules",
    "@nx",
    "jest",
    "src",
    "executors",
    "jest",
    "schema.json"
  }

  local config_path = sep .. table.concat(config_path_entries, sep)
  local config_json = read_json(config_path)

  if not config_json then return nil end

  local properties = config_json.properties or {}

  local lines = {}

  local useful_test_options = {
    "watch",
    "watchAll",
    "testNamePattern",
    "codeCoverage",
    "onlyChanged"
  }

  for key in pairs(properties) do
    if vim.tbl_contains(useful_test_options, key) then
      table.insert(lines, string.format("%s", key))
    end
  end



  return popup({
    items = lines,
    prompt = 'Select test option> ',
    fzf_opts = {
      ['--multi'] = true,
    },
    actions = {
      ['ctrl-r'] = function()
        callback()
      end,
      ["enter"] = function(selected)
        local selected_options = {}

        for _, option in ipairs(selected) do
          table.insert(selected_options, '--' .. option)
        end

        callback(selected_options)
      end,
    },
  })
end
