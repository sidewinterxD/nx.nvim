local get_node_version = require("nx.run.get_node_version")
local run = require("nx.run.terminal_function.run")

local nx_options = require("nx").options

return function(item)
  local run_cmd = "npx nx run " .. item
  local keyword = item:match("[%w_-]+:([%w_-]+)")

  -- check if nvm should be used
  if nx_options.nvm.enabled == true then
    return get_node_version(run_cmd, keyword, run)
  else
    run(run_cmd, keyword)
  end
end
