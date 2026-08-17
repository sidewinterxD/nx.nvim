local M = {}

local function check_executable(name, opts)
  opts = opts or {}
  if vim.fn.executable(name) == 1 then
    vim.health.ok(name .. " found")
    return true
  end
  local msg = name .. " not found"
  if opts.reason then
    msg = msg .. " - " .. opts.reason
  end
  if opts.optional then
    vim.health.warn(msg)
  else
    vim.health.error(msg)
  end
  return false
end

local function check_plugin(name, opts)
  opts = opts or {}
  if pcall(require, name) then
    vim.health.ok(name .. " installed")
    return true
  end
  local msg = name .. " not installed"
  if opts.reason then
    msg = msg .. " - " .. opts.reason
  end
  if opts.optional then
    vim.health.warn(msg)
  else
    vim.health.error(msg)
  end
  return false
end

M.check = function()
  -- Required system dependencies
  vim.health.start("nx: required dependencies")
  check_executable("node", { reason = "required to run nx commands" })
  check_executable("npm", { reason = "required to run nx commands" })
  check_executable("npx", { reason = "required to run nx commands" })
  check_plugin("fzf-lua", { reason = "required for picker UI" })

  -- Optional system dependencies
  vim.health.start("nx: optional dependencies")
  check_executable("tmux", { optional = true, reason = "terminal integration will use native terminal" })
  check_executable("herdr", { optional = true, reason = "terminal integration will use native terminal" })
  check_plugin("which-key", { optional = true, reason = "provides keymap group labels" })

  -- nvm: fish.nvm takes precedence, fall back to regular nvm
  local fish_nvm_ok, _ = pcall(vim.fn.system, "fish -c 'nvm --version'")
  if fish_nvm_ok and vim.v.shell_error == 0 then
    vim.health.ok("nvm found (fish.nvm)")
  elseif vim.fn.executable("nvm") == 1 then
    vim.health.ok("nvm found")
  else
    vim.health.warn("nvm not found - nvm integration will be disabled")
  end
end

return M
