local popup = require("nx.popup.fzf_lua_popup")

return function(cmd, run_options, callback)
  local split = 'Horizontal Split'
  run_options.split = split
  local debug = nil

  return popup({
    items = {
      "Horizontal Split | Default",
      "Vertical Split",
    },
    prompt = 'Select split> ',
    winopts = {
      title = ' Split Options ',
    },
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          if selected[1] then
            debug = false
            split = selected[1]
            run_options.split = split
            return callback(cmd, run_options)
          end
        end
      },
      {
        key = "ctrl-w",
        desc = 'Run in window',
        fn = function(selected)
          if selected[1] then
            split = ''
            run_options.layout_type = "window"
            callback(selected[1], run_options)
          end
        end
      },
      {
        key = 'Ctrl-r',
        desc = 'Default',
        fn = function()
          debug = false
          return callback(cmd, run_options)
        end
      },
      {
        key = 'Ctrl-d',
        desc = "Debug",
        fn = function(selected) -- debug, do not close pane/window on fail
          if selected[1] then
            split = selected[1]
            run_options.split = split
            debug = true

            vim.notify("nx: running command in debug", vim.log.levels.INFO)
            return callback(cmd, run_options, debug)
          end
        end
      },
      {
        key = "ctrl-c",
        desc = "Close",
        fn = function() return true end
      }
    }
  })
end
