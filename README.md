# nx.nvim

A Neovim plugin for [Nx](https://nx.dev) monorepo workflows. Run Nx commands without leaving your editor.
A fun little sideproject I made due to working with nx and missing easy command access.

## Features

- 🚀 Run Nx commands in a terminal (native Neovim terminal or tmux if available)
- 🐞 Debug mode keeps the newly created pane open when the process exits
- 🔧 nvm support (including `fish.nvm` for fish shell users)
- 🔍 Fuzzy-find workflows via fzf-lua
- 🕸️ Show Nx graph and project dependencies
- 📂 Jump to workspace, project directories, and config files (`nx.json`, `project.json`)

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [NX](https://nx.dev/)
- [node](https://nodejs.org/)
- [npm](https://www.npmjs.com/) / [npx](https://www.npmjs.com/package/npx)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)

## Optional

- [tmux](https://github.com/tmux/tmux) — run Nx commands in a tmux pane instead of the native terminal
- [Herdr](https://herdr.dev/) — run Nx commands in Herdr panes instead of native terminal
- [nvm](https://github.com/nvm-sh/nvm) — automatic Node version switching
- [fish.nvm](https://github.com/jorgebucaran/nvm.fish) — nvm support for fish shell users

NOTE: Choose either tmux or Herdr. Tmux takes precedence if both is enabled. :)

## Installation

Using [vim.pack](https://neovim.io/doc/user/packadd.html) (Neovim >= 0.12):

```lua
vim.pack.add({
  "https://github.com/sidewinterxD/nx.nvim",
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
    herdr = {
        enabled = false      -- run commands in herdr panel, if in a workspace
    },
    tmux = {
        enabled = false      -- run commands in tmux pane if in a tmux session
    },
    split_sizes = {          -- default split sizes. - NOTE herdr will convert to float. tmux will interperate as 20%
        horizontal = 20,
        vertical = 20,
    },
    shell = nil,             -- defaults to vim.o.shell
  }
})
```

## Keymaps

| Keymap         | Command                   | Description                         |
| -------------- | ------------------------- | ----------------------------------- |
| `<leader>nxr`  | `:NxRunRoot`              | Select command from root project    |
| `<leader>nxl`  | `:NxRunLocal`             | Select command from current project |
| `<leader>nxR`  | `:NxReRun`                | Re-run last command                 |
| `<leader>nxh`  | `:NxRunOldCmd`            | Select old command from history     |
| `<leader>nxW`  | `:NxReset`                | Reset Nx workspace (`npx nx reset`) |
| `<leader>nxjp` | `:NxJumpProject`          | Jump to project                     |
| `<leader>nxjw` | `:NxJumpWorkspace`        | Jump to workspace                   |
| `<leader>nxjn` | `:NxJumpWorkspaceConfig`  | Open nx.json                        |
| `<leader>nxjl` | `:NxJumpLocalProjectJson` | Open local project file             |
| `<leader>nxjP` | `:NxPickJumpProjectJson`  | Pick project file                   |
| `<leader>nxg`  | `:NxShowGraph`            | Show NX graph                       |

## Health Check

After installing, verify your setup by running:

```
:checkhealth nx
```

This will report the status of all required and optional dependencies.

## Feature Requests

Feature requests are welcome.
If you have an idea, please open an issue and describe your workflow and expected behavior.

## License

MIT

## Usage

> Documentation in progress
