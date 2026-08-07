local find_workspace_root = require("nx.utils.find_workspace_root")
local find_project_root = require("nx.utils.find_project_root")
local read_json = require("nx.utils.read_json")
local scan_for_project_json = require("nx.utils.scan_for_project_json")

local popup = require("nx.popup.fzf_lua_popup")
local sep = package.config:sub(1, 1)
local sep_pattern = sep:gsub("(%W)", "%%%1")

return function(opts)
  local options = opts or {}
  local workspace_root = find_workspace_root()

  if options.root == true then
    local nx_json = workspace_root .. sep .. "nx.json"
    if vim.fn.filereadable(nx_json) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(nx_json))
    else
      vim.notify("nx: no nx.json found in " .. workspace_root, vim.log.levels.INFO)
    end
    return
  end

  if options.current == true then
    local project_root = find_project_root(vim.api.nvim_buf_get_name(0))
    local project_json = project_root .. sep .. "project.json"
    if vim.fn.filereadable(project_json) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(project_json))
    else
      vim.notify("nx: no project.json found in " .. project_root, vim.log.levels.INFO)
    end
    return
  end

  local labels = {}
  local lookup = {}

  for _, pjpath in ipairs(scan_for_project_json(workspace_root) or {}) do
    local dec = read_json(pjpath)
    local project_name = (dec and dec.name) or "unknown"

    if not lookup[project_name] then
      labels[#labels + 1] = project_name
      lookup[project_name] = pjpath:match("(.*)" .. sep_pattern .. "project%.json$") or workspace_root
    end
  end

  if #labels == 0 then
    vim.notify("nx: no projects found in " .. workspace_root, vim.log.levels.INFO)
    return
  end

  return popup({
    items = labels,
    prompt = "Select NX project.json> ",
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          local item = selected[1] and lookup[selected[1]]
          if item then
            vim.cmd.edit(vim.fn.fnameescape(item .. sep .. "project.json"))
          end
        end
      },
    },
  })
end
