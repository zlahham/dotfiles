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
# asdf 0.16+ (Go rewrite) works purely via the shims on PATH — there is no
# asdf.sh to source anymore. Completions (optional):
export PATH="$HOME/.asdf/shims:$PATH"
[ -d "$HOME/.asdf/completions" ] && fpath=("$HOME/.asdf/completions" $fpath)

# ------------------------------------------------------------
#                      Zsh plugins
# ------------------------------------------------------------
# autosuggestions + syntax-highlighting (brew). Guarded so a missing install
# won't error. NOTE: syntax-highlighting must be sourced last.
_brew_share="/opt/homebrew/share"
[ -f "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_share

# ------------------------------------------------------------
#                      Prompt (starship)
# ------------------------------------------------------------
# Minimal dir + git prompt. Inert in Warp (honor_ps1=false -> Warp draws its
# own); shows up in tmux / iTerm / ssh. Config: ~/.config/starship.toml.
command -v starship >/dev/null && eval "$(starship init zsh)"
