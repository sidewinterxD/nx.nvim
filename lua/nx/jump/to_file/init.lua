local find_workspace_root = require("nx.utils.find_workspace_root")
local find_project_root = require("nx.utils.find_project_root")
local read_json = require("nx.utils.read_json")
local scan_for_project_json = require("nx.utils.scan_for_project_json")

local popup = require("nx.popup.fzf_lua_popup")
local sep = package.config:sub(1, 1)
local sep_pattern = sep:gsub("(%W)", "%%%1")

local function open_project_file(path)
  local project_path = path or vim.api.nvim_buf_get_name(0)
  local project_root = find_project_root(project_path)
  local candidates = { "nx.json", "project.json", "package.json" }

  for _, name in ipairs(candidates) do
    local file_path = project_root .. sep .. name
    if vim.fn.filereadable(file_path) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(file_path))
      return
    end
  end

  vim.notify(
    "nx: no project.json or package.json found in " .. project_root,
    vim.log.levels.INFO
  )
end

return function(opts)
  local options = opts or {}
  local workspace_root = find_workspace_root()

  if options.root == true then
    open_project_file(workspace_root)
    return
  end

  if options.current then
    open_project_file()
    return
  end

  local labels = {}
  local lookup = {}

  for _, pjpath in ipairs(scan_for_project_json(workspace_root) or {}) do
    local dec = read_json(pjpath)
    local project_name = (dec and dec.name) or "unknown"

    if not lookup[project_name] then
      labels[#labels + 1] = project_name
      lookup[project_name] = pjpath:match("(.*)" .. sep_pattern .. "project%.json$") or
          pjpath:match("(.*)" .. sep_pattern .. "package%.json$") or workspace_root
    end
  end

  if #labels == 0 then
    vim.notify("nx: no projects found in " .. workspace_root, vim.log.levels.INFO)
    return
  end

  return popup({
    items = labels,
    prompt = "Select NX project> ",
    keybinds = {
      {
        key = "Enter",
        desc = "Select",
        fn = function(selected)
          local item = selected[1] and lookup[selected[1]]
          return open_project_file(item)
        end
      },
    },
  })
end
