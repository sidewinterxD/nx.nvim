# nx.nvim Features

## Terminal Integration - tmux and native

- [x] Run Nx commands in native Neovim terminal
- [x] Run Nx commands in tmux pane (if available)
- [x] Run Nx command for current file's project
- [x] Run Nx command from history
- [x] Run Test with options
- [x] Re-run last command
- [x] Enable horizontal and vertical split
- [x] support for using nx bin directly from project instead relying on npx nx

## Node Version Management

- [x] nvm support
- [x] fish.nvm support (fish shell)

## Code Generation

- [ ] React component generation
- [ ] React hook generation
- [ ] React context generation
- [ ] Storybook story generation
- [ ] Generic generator picker (list all available Nx generators)

## Project Navigation

- [x] Fuzzy-find and jump to project root
- [x] Jump to Workspace root
- [x] fuzzy-find and jump to `project.json` or `package.json`
- [x] Jump to `project.json` or `package.json` for current project
- [x] Jump to workspace config (nx.json)

## Workspace Utilities

- [ ] show projects in workspace
- [ ] show targets in project
- [ ] Show affected projects (based on current git changes)
- [ ] Browse and filter projects by Nx tags
- [ ] View task pipeline / `dependsOn` chain for a target
- [x] Cache management (`nx reset`)
- [x] Support for target not from project.json files

## Editor Integration

- [ ] Pipe `nx lint` output into quickfix list
- [ ] Run tests for current buffer's project
- [ ] Statusline component showing current Nx project

## Diagnostics

- [x] `:checkhealth nx` integration
