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

  vim.cmd('normal! \27')

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  local start_row, start_col = start_pos[1], start_pos[2]
  local end_row, end_col = end_pos[1], end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 0 then return end

  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  lines[1] = string.sub(lines[1], start_col + 1)

  for _, target in ipairs(target_list_cache) do
    if target.project == project_name and target.command:match("test") then
      return switch(target.command, {
        layout_type = "pane",
        args = string.format("--testNamePattern '%s' --testFile '%s'", table.concat(lines, " "), file_path)
      })
    end
  end
end
