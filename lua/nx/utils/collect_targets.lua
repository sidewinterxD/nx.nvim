local find_project_root = require("nx.utils.find_project_root")
local get_nx_bin = require("nx.utils.get_nx_bin")

return function(root)
  root = root or find_project_root()

  local nx_bin = get_nx_bin()
  local target_list = {}

  local res = vim.system(
    { nx_bin, "graph", "--file=stdout", "--verbose" },
    { cwd = root, text = true }):wait()

  if res.code ~= 0 then
    vim.schedule(function()
      vim.notify("nx graph failed: " .. (res.stderr or ""), vim.log.levels.WARN)
    end)
    return
  end

  local ok, decoded = pcall(vim.json.decode, res.stdout or "")
  if not ok then
    return
  end

  local nodes = (((decoded or {}).graph or {}).nodes) or {}

  for name, node in pairs(nodes) do
    local targets = {}

    for target_name, _ in pairs((node.data and node.data.targets) or {}) do
      targets[#targets + 1] = target_name
      target_list[#target_list + 1] = {
        project = name,
        target = target_name,
        command = name .. ":" .. target_name,
      }
    end

    table.sort(targets)
  end

  return target_list
end
