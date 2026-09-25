local function format_bind_key(key)
  if not key or key == "" then
    return key
  end

  local k = key:lower()
  k = k:gsub("^ctrl[%+%-_]", "<c-")
  k = k:gsub("^control[%+%-_]", "<c-")
  k = k:gsub("^alt[%+%-_]", "<m-")
  k = k:gsub("^meta[%+%-_]", "<m-")
  k = k:gsub("^shift[%+%-_]", "<s-")
  k = k:gsub("[%+%-_]", "-")

  if k:match("^<") and not k:match(">$") then
    k = k .. ">"
  end

  return k
end

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
  local preview = opts.preview or nil
  local default_winopts = {
    border = opts.border or "rounded",
    width = opts.width or 0.3,
    height = opts.height or 0.4,
  }
  local winopts = vim.tbl_deep_extend("force", default_winopts, opts.winopts or {})

  if opts.keybinds then
    local footer_parts = {}

    for _, bind in ipairs(opts.keybinds) do
      local text = string.format(
        "\x1b[1;38;2;203;166;247m%s\x1b[0m %s",
        format_bind_key(bind.key),
        bind.desc
      )
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

    if #current_items == 0 then
      current_items = { "Loading..." }
    end

    table.sort(current_items, function(a, b)
      return a < b
    end)

    fzf_lua.fzf_exec(current_items, {
      prompt = prompt,
      fzf_opts = fzf_opts,
      winopts = winopts,
      preview = preview,
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
