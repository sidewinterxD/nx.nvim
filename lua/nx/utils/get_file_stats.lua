local stat_cache = require("nx").stat_cache

local uv = vim.loop

return function(path)
  if stat_cache[path] then
    return stat_cache[path]
  end

  local ok, stat = pcall(uv.fs_stat, path)
  if ok then
    stat_cache[path] = stat
    return stat
  end
  return nil
end
