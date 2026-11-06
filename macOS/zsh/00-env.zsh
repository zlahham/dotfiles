# Core environment + PATH. Runs first so everything below can rely on it.

# Don't hardcode TERM: tmux sets it to tmux-256color inside a session and Warp
# sets it outside. Forcing xterm-256color inside tmux breaks screen redraws
# (ghosted content, half-drawn pane borders). Only fall back if truly unset.
[ -z "$TERM" ] && export TERM='xterm-256color'
export LANG=en_GB.UTF-8
export EDITOR="$(which nvim)"
# The macOS/ tree of the dotfiles repo, wherever it was cloned. Derived from
# this file's real path: ~/.config/zsh is a symlink to <repo>/macOS/zsh, and :A
# resolves it, so :h:h is <repo>/macOS. An already-exported DOTFILES wins.
export DOTFILES="${DOTFILES:-${${(%):-%x}:A:h:h}}"
DISABLE_AUTO_TITLE=true

export GPG_TTY=$(tty)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# Respect a GOPATH set earlier (e.g. by a work ~/.zshenv); otherwise use Go's
# own default. Never clobber it — other tooling may resolve paths through it.
export GOPATH="${GOPATH:-$HOME/go}"
export PATH=$PATH:$GOPATH/bin
# asdf 0.16+ (Go rewrite) works purely via the shims on PATH — there is no
# asdf.sh to source anymore. Completions (optional):
export PATH="$HOME/.asdf/shims:$PATH"
[ -d "$HOME/.asdf/completions" ] && fpath=("$HOME/.asdf/completions" $fpath)
