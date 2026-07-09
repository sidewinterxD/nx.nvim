return function(generator_name)
  local fd_cmd = [[fd -H -t d --exclude .git --exclude .github --exclude .nx --exclude .vscode]]
  local fzf_path_cmd = [[fzf --tmux --header='Select a path' --prompt='Path> ' --layout=reverse --border]]
  local full_path_cmd = fd_cmd .. " | " .. fzf_path_cmd

  local result = vim.fn.systemlist(full_path_cmd)
  local initial_path = result[1] ~= "" and result[#result] or nil

  if not initial_path then
    print("No path selected.")
    return
  else
    vim.ui.input({
      prompt = "Confirm or edit path: ",
      default = initial_path,
      completion = "dir",
    }, function(component_path)
      if not component_path or component_path == "" then
        print("No path selected.")
        return
      end

      local name = component_path:match(".*/([^/]+)$")

      vim.ui.input({
        prompt = "Enter the name for the new component: ",
        default = name,
      }, function(component_name)
        if not component_name or component_name == "" then
          print("Component name is required.")
          return
        end

        local output = "npx nx generate @nx/react:"
          .. generator_name
          .. " --directory="
          .. component_path
          .. " --name="
          .. component_name
          .. " --style=scss --nameAndDirectoryFormat=as-provided"
        print("Running command: " .. output)
        vim.fn.system(output)
      end)
    end)
  end
end
