# nx.nvim

A Neovim plugin for [Nx](https://nx.dev) monorepo workflows. Run Nx commands, generate React components, and manage your workspace without leaving your editor.

## Features

- 🚀 Run Nx commands in a terminal (native Neovim terminal or tmux if available)
- ⚛️ React component generation
- 🔧 nvm support (including `fish.nvm` for fish shell users)
- 🔍 Fuzzy-find workflows via fzf-lua

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [node](https://nodejs.org/)
- [npm](https://www.npmjs.com/) / [npx](https://www.npmjs.com/package/npx)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)

## Optional

- [tmux](https://github.com/tmux/tmux) — run Nx commands in a tmux pane instead of the native terminal
- [nvm](https://github.com/nvm-sh/nvm) — automatic Node version switching
- [fish.nvm](https://github.com/jorgebucaran/nvm.fish) — nvm support for fish shell users

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  "you/nx.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  opts = {
    options = {
        -- .. options go here
    }
  }
}
```

Using [vim.pack](https://neovim.io/doc/user/packadd.html) (Neovim >= 0.12):

```lua
vim.pack.add({
  "https://github.com/you/nx.nvim",
  "https://github.com/ibhagwan/fzf-lua",
})
```

## Configuration

```lua
require("nx").setup({
  options = {
    nvm = {
        enabled = false      -- enable nvm support
    },
    tmux = {
        enabled = false      -- run commands in tmux pane if available
    },
    split_sizes = {          -- default split sizes
        horizontal = 12,
        vertical = 50,
    },
    shell = nil,             -- defaults to vim.o.shell
    skip_dirs = {            -- directories to ignore when searching for projects
      "node_modules", "dist", "build", "out",
      ".git", ".vscode", "target", "vendor"
    },
  }
})
```

## Keymaps

| Keymap        | Description                                    |
| ------------- | ---------------------------------------------- |
| `<leader>nxr` | Select and run a command from the root project |
| `<leader>nxg` | Generate a React component via `@nx/react`     |

## Health Check

After installing, verify your setup by running:

```
:checkhealth nx
```

This will report the status of all required and optional dependencies.

## Usage

> Documentation in progress

## License

MIT
