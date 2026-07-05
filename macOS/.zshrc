# ------------------------------------------------------------
#                         oh-my-zsh
# ------------------------------------------------------------
export TERM='xterm-256color'
export LANG=en_GB.UTF-8
export EDITOR="$(which nvim)"
export DOTFILES="$HOME/workspace/dotfiles/macOS"

HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=5000
SAVEHIST=5000
DISABLE_AUTO_TITLE=true

# source $HOME/.zshrc.plugins
# source $HOME/.zsh.theme
# source $ZSH/oh-my-zsh.sh

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
