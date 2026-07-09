local popup = require("nx.popup.fzf_lua_popup")

return function(cmd, keyword, node_version, callback)
  local split = 'Horizontal Split'
  return popup({
    items = {
      "Horizontal Split | Default",
      "Vertical Split",
    },
    prompt = 'Select split way> ',
    actions = {
      ['default'] = function(selected)
        if selected[1] then
          split = selected[1]

          return callback(cmd, keyword, node_version, split)
        end
      end,
      ['ctrl-r'] = function()
        return callback(cmd, keyword, node_version, split)
      end
    }
  })
end
