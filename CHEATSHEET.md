# Cheat Sheet

Quick reference for finding & searching files. Matches this repo's actual config
(fzf in `zsh/60-fzf.zsh`, nvim in `nvim/lua/plugins/editor.lua`). Expand as needed.

---

## Shell (zsh + fzf)

| Keys | Does |
|------|------|
| `Ctrl-T` | **Fuzzy-insert a file path** into the current command line |
| `Alt-C` | **Fuzzy `cd`** into a subdirectory |
| `Ctrl-R` | **Fuzzy history** search |
| `Ctrl-G` | **Live full-text search** across file *contents*, opens match in nvim at the line (also the `rgv` command) |

File lists are backed by ripgrep: hidden files included, `.gitignore` honoured, `.git` skipped.

Command-line word nav: `Alt-←/→` jump by word · `Alt-Backspace` kill word back · `Alt-Delete` kill word forward.

---

## Neovim (leader = `,`)

**Find a file**

| Keys | Does |
|------|------|
| `Ctrl-P` | **Find files** (tracked + untracked; respects `.gitignore`) |
| `,F` | Find files **including ignored + hidden** |
| `,b` | Switch **buffer** (open files) |
| `Ctrl-G` *(inside file picker)* | Toggle `.gitignore` filter on/off |

**Full-text search**

| Keys | Does |
|------|------|
| `\` | **Live grep** — search file contents across the project |

**File tree**

| Keys | Does |
|------|------|
| `Tab` | Toggle file tree |
| `,Tab` | Reveal current file in the tree |

**Jump around code (LSP)**

| Keys | Does |
|------|------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `Ctrl-O` | Jump **back** (older cursor position) |
| `Ctrl-G` | Jump **forward** (newer position — `Ctrl-I`/`Tab` is taken by the file tree) |

**Splits & tmux panes** (seamless)

| Keys | Does |
|------|------|
| `Ctrl-h/j/k/l` | Move between nvim splits *and* tmux panes |

---

## Mental model (same idea, three tools)

| I want to… | Shell | Neovim |
|------------|-------|--------|
| Find a file by **name** | `Ctrl-T` | `Ctrl-P` |
| Search file **contents** | `Ctrl-G` | `\` |
| Re-run a past command | `Ctrl-R` | — |
