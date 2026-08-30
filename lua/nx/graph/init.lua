local get_nx_bin = require("nx.utils.get_nx_bin")
local popup = require("nx.popup.fzf_lua_popup")
local cache = nil

local function build_fzf(data)
  local graph = data.graph
  local projects = vim.tbl_keys(graph.nodes)
  table.sort(projects)

  local deps_map = {}

  for src, deps in pairs(graph.dependencies) do
    for _, d in ipairs(deps) do
      if d.target then
        deps_map[d.target] = deps_map[d.target] or {}
        table.insert(deps_map[d.target], src)
      end
    end
  end

  popup({
    items = projects,
    prompt = "Nx Project> ",
    winopts = {
      title = " Nx Dependency Graph ",
      preview = {
        layout = "vertical",
        vertical = "down:60%"
      },
      height = 0.6,
      width = 0.5
    },
    preview = function(items)
      local proj = (type(items) == "table" and items[1]) or ""
      if proj == "" then return "No project selected" end

      local sections = {
        { title = "\27[1;32mDEPENDS ON\27[0m", list = vim.tbl_map(function(d) return d.target end, graph.dependencies[proj] or {}), color = "32" },
        { title = "\27[1;34mUSED BY\27[0m",    list = deps_map[proj] or {},                                                         color = "34" }
      }

      local lines = {
        string.format("\27[1;35mPROJECT:\27[0m \27[1m%s\27[0m", proj:upper()), string.rep("=", #proj + 9),
        ""
      }

      for _, sec in ipairs(sections) do
        table.insert(lines, string.format("%s (Count: %d):", sec.title, #sec.list))
        if #sec.list > 0 then
          for _, item in ipairs(sec.list) do table.insert(lines, string.format("  \27[%sm├──\27[0m %s", sec.color, item)) end
        else
          table.insert(lines, "  \27[90m(None)\27[0m")
        end
        table.insert(lines, "")
      end
      return table.concat(lines, "\n")
    end,
    fzf_opts = {
      ["--cycle"] = true,
    },
    keybinds = {
      {
        key = "Enter",
        desc = "Open project file",
        fn = function(selected)
          local proj = selected and selected[1]:match("^%s*(.-)%s*$") or ""
          local node = graph.nodes[proj]

          if not node or not node.data or not node.data.root then return end

          local found = vim.fs.find({ "project.json", "package.json" }, { path = node.data.root, limit = 1 })

          if #found > 0 then vim.cmd("edit " .. found[1]) end
        end
      },
      {
        key = "Ctrl-n",
        desc = "Move down",
      },
      {
        key = "Ctrl-p",
        desc = "Move up",
      },
      {
        key = "Ctrl-c",
        desc = "Close",
        fn = function() return true end
      }
    }
  })
end

return function(opts)
  if opts and opts.refresh then cache = nil end
  if cache then return build_fzf(cache) end

  local nx_bin = get_nx_bin()

  vim.system({ nx_bin, "graph", "--file=stdout" }, { text = true }, function(obj)
    if obj.code ~= 0 or not obj.stdout then return end

    local raw = obj.stdout:sub(obj.stdout:find("{") or 1)
    local ok, decoded = pcall(vim.json.decode, raw)

    if not (ok and decoded and decoded.graph) then return end

    cache = decoded
    vim.schedule(function() build_fzf(cache) end)
  end)
end
