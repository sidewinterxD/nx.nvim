local vim = vim
local sep = package.config:sub(1, 1)

return function()
  local path = vim.fn.expand("%:p:h")

  -- Fall back to cwd if buffer ministarter
  if path == "" or path:match("^ministarter") then
    path = vim.fn.getcwd()
  end

  while path ~= "/" do
    if vim.fn.filereadable(path .. sep .. "nx.json") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end
