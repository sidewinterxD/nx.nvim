local get_file_stats = require("nx.utils.get_file_stats")

local fn = vim.fn
local sep = package.config:sub(1, 1)

return function(file_path)
  local path = fn.getcwd()

  if file_path and file_path ~= "" then
    path = file_path
  end

  while path ~= "" and path ~= sep do
    if get_file_stats(path .. sep .. "project.json") then
      return path
    elseif get_file_stats(path .. sep .. "package.json") then
      return path
    end

    local parent = fn.fnamemodify(path, ":h")
    if parent == path then
      break
    end
    path = parent
  end

  return fn.getcwd()
end
