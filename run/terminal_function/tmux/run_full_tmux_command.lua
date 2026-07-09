local fn = vim.fn

return function(cmds)
  for _, tmux_cmd in ipairs(cmds) do
    fn.jobstart(tmux_cmd, { detach = true, stdout_buffered = false })
  end
end
