local find_project_root = require("nx.utils.find_project_root")

return function()
  local root = find_project_root()

  local nx_bin = "nx"
  local local_nx_bin = root .. "/node_modules/.bin/nx"

  if vim.fn.executable(nx_bin) == 0 then
    if vim.fn.executable(local_nx_bin) == 1 then
      nx_bin = local_nx_bin
    else
      return
    end
  end

  return nx_bin
end
