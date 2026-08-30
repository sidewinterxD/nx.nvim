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
  }

  local dist_config_path = sep .. table.concat(vim.list_extend(vim.deepcopy(config_path_entries), {
    "dist",
    "src",
    "executors",
    "jest",
    "schema.json",
  }), sep)

  local src_config_path = sep .. table.concat(vim.list_extend(vim.deepcopy(config_path_entries), {
    "src",
    "executors",
    "jest",
    "schema.json",
  }), sep)

  local config_json = read_json(dist_config_path) or read_json(src_config_path)

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
    prompt = 'Select option> ',
    winopts = {
      title = ' NX Jest Options ',
    },
    fzf_opts = {
      ['--multi'] = true,
    },
    keybinds = {
      {
        key = 'Ctrl-r',
        desc = "Run with no options",
        fn = function()
          callback()
        end
      },
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          local selected_options = {}

          for _, option in ipairs(selected) do
            table.insert(selected_options, '--' .. option)
          end

          callback(selected_options)
        end
      },
      {
        key = "ctrl-c",
        desc = "Close",
        fn = function() return true end
      }
    },
  })
end
