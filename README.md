# dotfiles

Personal configuration for my macOS and Linux machines. Editing a config file
*is* the change — the only "run" action is applying everything with a setup
script that symlinks each file into `$HOME`.

> The repo lives at `~/workspace/dotfiles` — that path is hardcoded in the
> symlinks and setup scripts.

## Layout

Two self-contained trees, one per platform:

- **`macOS/`** — actively maintained (Apple Silicon). The superset.
- **`linux/`** — older, apt-based. **Currently broken; will be redone on a Linux box.**

The same dotfile (`.aliases`, `.zshrc`, `.gitconfig`, …) exists independently in
each tree, so a macOS change never touches Linux and vice versa.

## What's in `macOS/`

| Path | What it configures |
|------|--------------------|
| `.zshrc`, `.aliases` | zsh (no oh-my-zsh; plugins sourced directly) |
| `.gitconfig`, `.gitignore_global` | git |
| `.tmux.conf` | tmux (prefix `C-a`, tpm plugins, session persistence) |
| `nvim/` | Neovim — Lua config on lazy.nvim (whole dir symlinked to `~/.config/nvim`) |
| `themes/starship.toml` | starship prompt (shown in tmux/iTerm/ssh) |
| `warp/` | Warp terminal settings + theme |
| `claude/` | Claude Code settings + statusline |
| `Brewfile` | Homebrew packages/casks |
| `.gemrc`, `.rspec` | Ruby tooling |
| `setup.sh` | the installer (below) |

Neovim, Ruby (LSP), Node, etc. are managed via [asdf]; there's no `.ruby-version`
in the repo.

## Applying

```sh
bash macOS/setup.sh          # everything: symlinks + brew + Warp + nvim + asdf + tmux
```

Re-running is safe (symlinks are forced/idempotent). Skip parts with flags:

```sh
bash macOS/setup.sh --links-only   # just refresh the symlinks
bash macOS/setup.sh --no-bundle    # everything except the heavy brew installs
bash macOS/setup.sh -h             # full flag list
```

## Local / secret config (never committed)

`.zshrc` sources two files that setup creates empty and the repo ignores:

- `~/.env` — secrets / environment variables
- `~/.zshrc.local` — machine-specific zsh

Put anything machine- or secret-specific there, not in the tracked dotfiles.
