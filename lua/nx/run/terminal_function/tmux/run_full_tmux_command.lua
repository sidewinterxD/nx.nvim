local fn = vim.fn

return function(cmds, run_options)
  if run_options.layout_type == "window" then
    vim.notify("Running command in new window", vim.log.levels.INFO)
  end

  for _, tmux_cmd in ipairs(cmds) do
    fn.jobstart(tmux_cmd, { detach = true, stdout_buffered = false })
  end
end
