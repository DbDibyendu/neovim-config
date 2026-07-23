# Agent Notes

## Repository Purpose

This is a personal macOS dotfiles repository. It is intended to be linked into
`$HOME` with GNU Stow and currently contains configuration for:

- Neovim under `.config/nvim`
- WezTerm under `.config/wezterm`
- tmux in `.tmux.conf`
- zsh in `.zshrc`
- git in `.gitconfig`
- macOS/Homebrew bootstrap helpers in `ansible-setup.yml`
- local helper scripts such as `vpn.sh` and `no_sleep.py`

The setup is macOS and Homebrew first. Do not assume Linux portability unless
the user explicitly asks for it.

## Layout

- `.config/nvim/init.lua` loads the Neovim config from `lua/db`.
- `.config/nvim/lua/db/core` contains base options and keymaps.
- `.config/nvim/lua/db/plugins` contains lazy.nvim plugin specs, including
  LSP and DAP specs in nested `lsp` and `dap` directories.
- `.config/nvim/ftplugin/java.lua` contains Java/JDTLS-specific startup logic.
- `.config/wezterm/wezterm.lua` configures WezTerm, pane/tab keymaps, and the
  tabline plugin.
- `.tmux.conf`, `.zshrc`, and `.gitconfig` are linked directly into `$HOME`.

## Neovim Context

- Entry point: `.config/nvim/init.lua` requires `db.lazy` first, then
  `db.core`.
- Plugin manager: `.config/nvim/lua/db/lazy.lua` bootstraps `lazy.nvim` into
  Neovim's data directory and imports all specs from `db.plugins`,
  `db.plugins.lsp`, and `db.plugins.dap`.
- Core config:
  - `core/options.lua` sets editor defaults such as relative numbers, 2-space
    indentation, dark true-color UI, system clipboard, split direction, disabled
    swapfile, and a `%F` winbar.
  - `core/keymaps.lua` sets `<Space>` as leader, registers which-key groups,
    defines split/tab/navigation mappings, copy-path mappings, GitHub remote
    open mapping, Treesitter folds, and terminal/window navigation.
- LSP setup:
  - `plugins/lsp/mason.lua` installs common servers and tools through Mason,
    including Go, Lua, TypeScript, Rust, Java, XML, Prettier, Stylua, ESLint,
    and `google-java-format`.
  - `plugins/lsp/lspconfig.lua` uses the Neovim 0.11 `vim.lsp.config` API for
    global capabilities and relies on current `mason-lspconfig` behavior to
    auto-enable installed servers.
  - `jdtls` is intentionally disabled for generic `vim.lsp.enable` and handled
    by `ftplugin/java.lua` through `nvim-jdtls`.
- Java/JDTLS:
  - `ftplugin/java.lua` derives the Mason `jdtls` package path, picks macOS ARM
    or Intel config, finds project root markers, creates a per-project cache
    workspace, and starts JDTLS with Lombok support.
  - Java runtime paths are machine-specific. Be careful before changing them;
    prefer deriving paths with `/usr/libexec/java_home` when making the config
    more portable.
- DAP/debugging:
  - `plugins/dap/nvim-dap.lua` wires `nvim-dap`, `dap-go`, DAP UI, virtual
    text, and persistent breakpoints.
  - Debugging keymaps are grouped under `<leader>z`; Go test debugging uses
    `<leader>zg`.
- Formatting:
  - `plugins/formatting.lua` uses `conform.nvim`, formats on save, and disables
    LSP fallback. Add explicit formatters for new filetypes if formatting is
    expected.
- Search/navigation:
  - Telescope is configured for hidden files, ripgrep-backed file search, FZF
    native sorting, DAP extension support, and project-local recent files.
  - Some live-grep exclusions are personal workflow choices. Do not remove them
    unless the user asks or they clearly break the requested behavior.

## WezTerm Context

- Main config: `.config/wezterm/wezterm.lua`.
- The config uses `wezterm.config_builder()` when available and requires the
  external `tabline.wez` plugin from GitHub.
- Font/UI assumptions:
  - Font is `JetBrains Mono` at size `14`.
  - Initial window size is large (`100` rows, `180` columns).
  - Window decorations are set to `RESIZE`.
  - Tab bar is visible, unfancy, and placed at the bottom.
  - Window padding uses a larger top padding and zero side/bottom padding.
- Leader key: `CTRL-Space` with a 1500 ms timeout. This intentionally mirrors a
  tmux-style workflow.
- Important keybindings:
  - `LEADER + ,` renames the current tab.
  - `LEADER + c` opens a new tab.
  - `LEADER + x` closes the current pane with confirmation.
  - `LEADER + b/n` moves to previous/next tab.
  - `LEADER + v` splits right; `LEADER + -` splits vertically.
  - `LEADER + h/j/k/l` navigates panes.
  - `LEADER + Arrow` resizes panes.
  - `LEADER + z` toggles pane zoom.
  - `LEADER + 0..9` activates tabs by index.
- Session manager events:
  - `LEADER + s` emits `save_session`.
  - `LEADER + l` emits `load_session`.
  - `LEADER + r` emits `restore_session`.
  - These depend on the configured WezTerm session manager/plugin being present
    under `.config/wezterm` or installed as expected by the README/setup.
- Tab titles are customized from the active pane working directory. If changing
  tabline behavior, preserve the current cwd-focused mental model unless asked
  otherwise.

## Editing Guidance

- Keep changes small and scoped to the user request.
- Preserve personal workflow choices unless the user asks to change behavior.
- Prefer matching the existing Lua module structure for Neovim changes.
- Do not rewrite plugin organization or keymap conventions without a clear
  reason.
- Do not edit generated caches, lock files, or local editor metadata unless the
  request specifically requires it.

## Safety

- Do not add secrets, passwords, API keys, SDK keys, tokens, or real `.env`
  contents to the repo.
- Treat `.zshrc`, `.gitconfig`, `vpn.sh`, and any env-loading scripts as
  sensitive areas because they may reference credentials or machine-local paths.
- Do not commit local IDE workspace state, generated cache files, downloaded
  plugins, or machine-specific credentials.
- If a change would expose or move a secret, stop and ask the user how they want
  to handle rotation and storage.

## Useful Checks

Run these from the repo root when reviewing or changing the setup:

```sh
git status --short
rg --files
```

For a non-mutating Neovim startup check that avoids writing to the user's real
cache/state directories:

```sh
XDG_CONFIG_HOME="$PWD/.config" \
XDG_CACHE_HOME=/tmp/nvim-config-review-cache \
XDG_STATE_HOME=/tmp/nvim-config-review-state \
nvim --headless +qa
```

Useful interactive Neovim checks after startup:

- `:Lazy`
- `:Mason`
- `:checkhealth`
