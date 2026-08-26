return function(opts)
  local fzf_lua = require("fzf-lua")

  opts = opts or {}
  local items = opts.items or {}
  local prompt = opts.prompt or "Select> "
  local actions = opts.actions or {}
  local files = opts.files or {}
  local grep = opts.grep or {}
  local fzf_opts = opts.fzf_opts or {}
  local filter = opts.filter or nil

  if opts.keybinds then
    local footer_parts = {}
    for _, bind in ipairs(opts.keybinds) do
      local text = string.format("\x1b[1;38;2;203;166;247m%s\x1b[0m %s", bind.key, bind.desc)
      footer_parts[#footer_parts + 1] = text
      if bind.fn then
        local fzf_key = bind.key:lower():gsub("<", ""):gsub(">", "")
        actions[fzf_key] = bind.fn
      end
    end
    fzf_opts["--footer"] = table.concat(footer_parts, " │ ")
  end

  local function open(current_items)
    if filter and type(filter) == "function" then
      current_items = filter(current_items)
    end

    fzf_lua.fzf_exec(current_items, {
      prompt = prompt,
      fzf_opts = fzf_opts,
      winopts = {
        border = opts.border or "rounded",
        width = opts.width or 0.3,
        height = opts.height or 0.4,
      },
      actions = actions,
      files = files,
      grep = grep,
    })
  end

  open(items)

  return {
    update = function(new_items)
      items = new_items or {}
      vim.schedule(function()
        open(items)
      end)
    end,
  }
end
