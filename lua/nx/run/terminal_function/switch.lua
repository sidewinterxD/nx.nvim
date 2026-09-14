local get_node_version = require("nx.run.get_node_version")
local run = require("nx.run.terminal_function.run")
local get_nx_bin = require("nx.utils.get_nx_bin")

local nx_options = require("nx").options

return function(item, run_options)
  local nx_bin = get_nx_bin()
  local run_cmd = nx_bin .. " run " .. item
  local keyword = item:match("[%w_-]+:([%w_-]+)")

  run_options.keyword = keyword
  run_options.cmd = run_cmd


  -- check if nvm should be used
  if nx_options.nvm.enabled == true then
    return get_node_version(run_cmd, run_options, run)
  else
    run(run_cmd, run_options)
  end
end
