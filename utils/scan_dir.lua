local vim = vim
local uv = vim.loop

return function(path)
  local handle = uv.fs_scandir(path)
  if not handle then
    return nil
  end

  local entries = {}
  while true do
    local name, typ = uv.fs_scandir_next(handle)
    if not name then
      break
    end
    entries[#entries + 1] = { name = name, type = typ }
  end
  return entries
end
