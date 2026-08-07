local popup = require("nx.popup.fzf_lua_popup")

return function(cmd, keyword, node_version, callback)
  local split = 'Horizontal Split'
  local debug = nil
  return popup({
    items = {
      "Horizontal Split | Default",
      "Vertical Split",
    },
    prompt = 'Select split way> ',
    actions = {
      ['default'] = function(selected)
        if selected[1] then
          debug = false
          split = selected[1]
          return callback(cmd, keyword, node_version, split)
        end
      end,
      ['ctrl-r'] = function()
        debug = false
        return callback(cmd, keyword, node_version, split)
      end,
      ['ctrl-d'] = function() -- debug, do not close pane/window on fail
        debug = true
        vim.notify("nx: running command in debug", vim.log.levels.INFO)
        return callback(cmd, keyword, node_version, split, debug)
      end,
    }
  })
end
