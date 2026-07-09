local nx_options = require('nx').options

return function(cmd, split)
  local split_direction = split -- Horizontal Split or Vertical Split
  local direction_cmd = split_direction == "Vertical Split" and "vsplit" or "split"
  local size_cmd = "resize " .. nx_options.split_sizes.horizontal

  if split_direction == "Vertical Split" then
    size_cmd = "vertical resize " .. nx_options.split_sizes.vertical
  end

  vim.cmd("botright " .. direction_cmd .. " | enew" .. " | " .. size_cmd)
  vim.fn.termopen(cmd)
  vim.cmd("startinsert")
end
