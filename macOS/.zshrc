# ------------------------------------------------------------
#                         Shell
# ------------------------------------------------------------
export TERM='xterm-256color'
export LANG=en_GB.UTF-8
export EDITOR="$(which nvim)"
export DOTFILES="$HOME/workspace/dotfiles/macOS"

HISTFILE="$HOME/.zsh_history"   # oh-my-zsh used to set this; keep history persistent
HISTSIZE=5000
SAVEHIST=5000
DISABLE_AUTO_TITLE=true

# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

source $HOME/.aliases

create_pr() {
  base_branch="${1:-main}"
  branch=$(git rev-parse --abbrev-ref HEAD)
  pr_title=$(git log -1 --pretty=%s)
  pr_body=$(git log -1 --pretty=%b)

  git push -u origin "$branch" || return 1

  gh pr create \
    --title "$pr_title" \
    --body "$pr_body" \
    --base "$base_branch" \
    --head "$branch" \
    --draft
}

# ------------------------------------------------------------
#                        ENV VARIABLES
# ------------------------------------------------------------

source $HOME/.env

# ------------------------------------------------------------
#                      User Configuration
# ------------------------------------------------------------


bindkey "\e\eOD" backward-word
bindkey "\e\eOC" forward-word

source $HOME/.zshrc.local

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

export GPG_TTY=$(tty)
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.asdf/shims:$PATH"
. $(brew --prefix asdf)/libexec/asdf.sh

# ------------------------------------------------------------
#                      Zsh plugins
# ------------------------------------------------------------
# autosuggestions + syntax-highlighting (brew). Guarded so a missing install
# won't error. `brew --prefix` resolves /opt/homebrew (ARM) or /usr/local (Intel).
# NOTE: syntax-highlighting must be sourced last.
_brew_share="$(brew --prefix 2>/dev/null)/share"
[ -f "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_share
