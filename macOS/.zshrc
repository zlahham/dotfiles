# ------------------------------------------------------------
#                         oh-my-zsh
# ------------------------------------------------------------
# Path to your oh-my-zsh installation.
export TERM='xterm-256color'
export LANG=en_GB.UTF-8
export EDITOR="$(which vim)"
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/workspace/dotfiles/macOS"
export SSH_KEY_PATH="~/.ssh/dsa_id"
export NVM_DIR="$HOME/.nvm"
. /usr/local/etc/profile.d/z.sh

# I like: 'dst', 'ys', 'steeef', 'spaceship', 'powerlevel9k/powerlevel9k'
ZSH_THEME="ys"
HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=500
SAVEHIST=500
DISABLE_AUTO_TITLE=true
DISABLE_UPDATE_PROMPT=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv nvm vcs)
POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=true
POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=true


plugins=(
  brew
  git
  rails
  # tmux
  zsh-syntax-highlighting
  z
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

source $HOME/.aliases

# ------------------------------------------------------------
#                        ENV VARIABLES
# ------------------------------------------------------------

source $HOME/.env

# ------------------------------------------------------------
#                      User Configuration
# ------------------------------------------------------------

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

# rbenv
eval "$(rbenv init - --no-rehash)"

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use # This loads nvm

# Local provision file for zsh
source $HOME/.zshrc.local
