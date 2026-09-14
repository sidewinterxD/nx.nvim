local popup = require("nx.popup.fzf_lua_popup")
local nx_options = require("nx").options
local shell = nx_options.shell or vim.o.shell

local function parse_version(line)
  return line:match("v(%d+%.%d+%.%d+)")
end

return function(cmd, run_options, callback)
  local nvm_list_output = vim.fn.systemlist(shell .. " -c 'nvm list | grep -v system'")


  if #nvm_list_output == 0 then
    vim.notify("No Node versions found via nvm", vim.log.levels.WARN)
    return callback(cmd, run_options, nil)
  end

  if #nvm_list_output == 1 then
    run_options.node_version = parse_version(nvm_list_output[1])
    return callback(cmd, run_options)
  end

  return popup({
    items = nvm_list_output,
    prompt = 'Select version> ',
    winopts = {
      title = ' Node Versions ',
    },
    keybinds = {
      {
        key = "Enter",
        desc = 'Select',
        fn = function(selected)
          if selected[1] then
            run_options.node_version = parse_version(selected[1])
            return callback(cmd, run_options)
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
