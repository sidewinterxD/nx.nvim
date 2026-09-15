local find_project_root = require("nx.utils.find_project_root")
local switch = require("nx.run.terminal_function.switch")
local target_list_cache = require("nx").target_list

return function()
  local file_path = vim.api.nvim_buf_get_name(0)
  local project_root = find_project_root(file_path)
  local project_name = project_root and vim.fs.basename(project_root) or nil

  if not project_root then
    print("Project root not found for file: " .. file_path)
    return
  end

  if not target_list_cache or #target_list_cache == 0 then
    print("No targets found in cache")
    return
  end

  for _, target in ipairs(target_list_cache) do
    if target.project == project_name and target.command:match("test") then
      return switch(target.command, {
        args = string.format("--all") }
      )
    end
  end
end
