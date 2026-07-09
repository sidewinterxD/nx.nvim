local file_cache = require("nx").file_cache
local vim = vim
local json_decode = vim.json and vim.json.decode or vim.fn.json_decode


return function(path)
  if file_cache[path] ~= nil then
    return file_cache[path]
  end

  local f = io.open(path, "r")
  if not f then
    file_cache[path] = nil
    return nil
  end

  local content = f:read("*a")
  f:close()

  if not content or content == "" then
    file_cache[path] = nil
    return nil
  end

  local ok, decoded = pcall(json_decode, content)
  if not ok then
    file_cache[path] = nil
    return nil
  end

  file_cache[path] = decoded
  return decoded
end
