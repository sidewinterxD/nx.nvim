# nx.nvim Features

## Terminal Integration - tmux and native

- [x] Run Nx commands in native Neovim terminal
- [x] Run Nx commands in tmux pane (if available)
- [x] Run Nx command for current file's project
- [x] Run Nx command from history
- [x] Run Test with options
- [x] Re-run last command
- [x] Enable horizontal and vertical split

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

- [ ] Fuzzy-find and jump to project root
- [ ] Jump to `project.json` for current project
- [ ] Jump to test file for current buffer
- [ ] Toggle between source and test file

## Workspace Utilities

- [ ] Show affected projects (based on current git changes)
- [ ] Browse and filter projects by Nx tags
- [ ] View task pipeline / `dependsOn` chain for a target
- [ ] Cache management (`nx reset`)

## Editor Integration

- [ ] Pipe `nx lint` output into quickfix list
- [ ] Run tests for current buffer's project
- [ ] Statusline component showing current Nx project

## Diagnostics

- [x] `:checkhealth nx` integration
