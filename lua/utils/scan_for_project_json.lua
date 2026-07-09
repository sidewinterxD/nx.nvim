local fn = vim.fn

local scandir = require("nx.utils.scan_dir")
local get_file_stats = require("nx.utils.get_file_stats")

local sep = package.config:sub(1, 1)

local SKIP_DIRS = {
  node_modules = true,
  [".git"] = true,
  dist = true,
  build = true,
  [".next"] = true,
  public = true,
  [".nx"] = true,
  [".vscode"] = true,
  [".idea"] = true,
  target = true,
}

return function(root, max_depth, max_results)
  max_depth = max_depth or 3
  max_results = max_results or 200

  local results = {}

  local function recurse(path, depth)
    if #results >= max_results or depth > max_depth then
      return
    end

    local dir_name = fn.fnamemodify(path, ":t")
    if SKIP_DIRS[dir_name] then
      return
    end

    local entries = scandir(path)
    if not entries then
      return
    end

    for _, e in ipairs(entries) do
      if e.name == "project.json" then
        results[#results + 1] = path .. sep .. "project.json"
        if #results >= max_results then
          return
        end
      elseif e.type == "directory" and not SKIP_DIRS[e.name] then
        recurse(path .. sep .. e.name, depth + 1)
        if #results >= max_results then
          return
        end
      end
    end
  end

  if not SKIP_DIRS[root] then
    recurse(root, 0)
  end

  for _, sub in ipairs({ "apps", "libs" }) do
    local dir = root .. sep .. sub
    if get_file_stats(dir) and #results < max_results and not SKIP_DIRS[sub] then
      recurse(dir, 0)
    end
  end

  return results
end
