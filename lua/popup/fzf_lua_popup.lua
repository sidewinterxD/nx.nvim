return function(opts)
  local fzf_lua = require("fzf-lua")

  opts = opts or {}
  local items = opts.items or {}
  local prompt = opts.prompt or "Select> "
  local actions = opts.actions or {}
  local files = opts.files or {}
  local grep = opts.grep or {}
  local fzf_opts = opts.fzf_opts or {}

  fzf_lua.fzf_exec(items, {
    prompt = prompt,
    fzf_opts = fzf_opts,
    winopts = {
      border = opts.border or 'rounded',
      width = opts.width or 0.3,
      height = opts.height or 0.4,
    },
    actions = actions,
    files = files,
    grep = grep
  })
end
