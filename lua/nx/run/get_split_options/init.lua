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
    fzf_opts = {
      ["--footer"] = "\x1b[1;36mEnter\x1b[0m Select │ \x1b[1;36mCtrl-r\x1b[0m Default │ \x1b[1;36mCtrl-d\x1b[0m Debug"
    },
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          if selected[1] then
            debug = false
            split = selected[1]
            return callback(cmd, keyword, node_version, split)
          end
        end
      },
      {
        key = 'Ctrl-r',
        desc = 'Default',
        fn = function()
          debug = false
          return callback(cmd, keyword, node_version, split)
        end
      },
      {
        key = 'Ctrl-d',
        desc = "Debug",
        fn = function() -- debug, do not close pane/window on fail
          debug = true
          vim.notify("nx: running command in debug", vim.log.levels.INFO)
          return callback(cmd, keyword, node_version, split, debug)
        end
      },
    }
  })
end
