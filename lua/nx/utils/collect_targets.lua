local find_project_root = require("nx.utils.find_project_root")
local get_nx_bin = require("nx.utils.get_nx_bin")

return function(root, callback)
  root = root or find_project_root()
  local nx_bin = get_nx_bin()

  vim.system(
    { nx_bin, "graph", "--file=stdout", "--verbose" },
    { cwd = root, text = true },
    function(res)
      if res.code ~= 0 then
        vim.schedule(function()
          vim.notify("nx graph failed: " .. (res.stderr or ""), vim.log.levels.WARN)
          callback(nil)
        end)
        return
      end

      local ok, decoded = pcall(vim.json.decode, res.stdout or "")
      if not ok then
        vim.schedule(function() callback(nil) end)
        return
      end

      local nodes = (((decoded or {}).graph or {}).nodes) or {}
      local target_list = {}
      local project_list = {}

      for name, node in pairs(nodes) do
        project_list[#project_list + 1] = {
          name = name,
        }
        for target_name, _ in pairs((node.data and node.data.targets) or {}) do
          target_list[#target_list + 1] = {
            project = name,
            target = target_name,
            command = name .. ":" .. target_name,
          }
        end
      end

      vim.schedule(function() callback(target_list, project_list) end)
    end
  )
end
