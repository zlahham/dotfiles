# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles for the user's Linux and macOS machines. No build, test, or lint step — editing a
config file *is* the change. The only "run" action is applying the dotfiles via a setup script.

## Repository structure

Two self-contained, parallel trees — one per platform:

- `macOS/` — actively maintained. Superset: also holds `claude/`, `themes/`,
  `warp/` (Warp terminal config), `nvim/` (Lua config), and a `Brewfile`.
- `linux/` — older, apt-based. Lacks the macOS-only extras above.
- `fonts/` — Powerline / Nerd Font files copied into place by the Linux setup.

The same dotfile (e.g. `.aliases`, `.zshrc`, `.gitconfig`) exists **independently in both trees**.
A change to macOS behaviour does not touch Linux and vice versa. When a change should apply to both
platforms, edit both copies.

## How it works: symlink + setup.sh

`<platform>/setup.sh` symlinks each tracked file from `~/workspace/dotfiles/<platform>/` into `$HOME`
(e.g. `ln -s -f .../macOS/.zshrc ~/.zshrc`). Two hard assumptions:

1. **Repo path is `~/workspace/dotfiles`** — hardcoded in every symlink and in `$DOTFILES` in
   `macOS/.zshrc`. Do not assume the repo location is discoverable; it is fixed.
2. **A new dotfile takes effect only after its symlink is added to `setup.sh`.** Adding a file to the
   tree is not enough — add the matching `ln -s -f` line (and re-run `setup.sh`), or it is dead weight.

`macOS/setup.sh` does more than symlink: installs Homebrew, installs Warp early, runs `brew bundle`
(`macOS/Brewfile`), sets zsh as default shell, creates empty `~/.env` + `~/.zshrc.local`, syncs
neovim plugins via lazy.nvim (headless `Lazy! sync`), sets up asdf (adds ruby/nodejs plugins).
No oh-my-zsh — zsh plugins (autosuggestions, syntax-highlighting) are sourced from the zsh fragments
(see below), not a framework. `linux/setup.sh` is the apt
equivalent (Vundle instead of lazy.nvim, rbenv cloned from source, tpm for tmux).

The macOS neovim config is Lua: `macOS/nvim/init.lua` (options/keymaps/autocmds) + `lua/plugins/*.lua`
(lazy.nvim specs). The **whole `nvim/` dir** is symlinked to `~/.config/nvim` (not a single file), and
`lazy-lock.json` is committed to pin plugin versions. LSP servers install on demand via mason.

The macOS zsh config is modular like nvim: `macOS/.zshrc` is a **thin loader** that sources
`~/.config/zsh/*.zsh` in filename order; the **whole `zsh/` dir** is symlinked to `~/.config/zsh`. Each
numbered fragment owns one concern (`00-env`, `10-history`, `20-sources`, `30-keybindings`,
`40-completion`, `50-plugins`, `60-fzf`, `70-prompt`, `99-local`). The numeric prefixes **are** the load
order — step by 10 so a new concern slots in without renumbering. Order that matters: `40-completion`
before `50-plugins`/`60-fzf`, syntax-highlighting last within `50-plugins`, `99-local` (machine
overrides) last of all. Edit a fragment, not `.zshrc`.

## Applying / testing changes

```sh
bash macOS/setup.sh      # macOS: symlink + brew + Warp + nvim plugins + asdf
bash linux/setup.sh      # Linux: apt + symlink + Vundle + rbenv + tpm
```

Symlinks are `-f` (force), so re-running is safe and idempotent for the linking step.

## Local / secret config (never committed)

`.zshrc` sources two files created empty by setup and left out of the repo:
`~/.env` (secrets/env vars) and `~/.zshrc.local` (machine-specific zsh). Put machine- or secret-specific settings there,
not in the tracked dotfiles.

## Conventions worth knowing

- **zsh**: `macOS/.aliases` aliases `vim`→`nvim`, `cat`→`bat`, plus a large git alias block; `cd` is
  overridden to auto-`ll`. `create_pr()` in `.aliases` opens a **draft** PR from the last commit's
  subject/body via `gh` (base defaults to `main`).
- **Claude Code config is itself a dotfile**: `macOS/claude/settings.json` and
  `macOS/claude/scripts/statusline.py` symlink into `~/.claude/`. Editing Claude Code settings for this
  machine means editing those tracked files.
- **Editor**: neovim is the only editor (`EDITOR=nvim`, `vim`→`nvim` alias). Config is Lua under
  `macOS/nvim/`. Plain-vim configs (`.vimrc.*`, Vundle) were removed — no bare-vim setup remains.
