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
# . /usr/local/etc/profile.d/z.sh

# I like: 'dst', 'ys', 'steeef', 'spaceship', 'powerlevel9k/powerlevel9k'
# ZSH_THEME="powerlevel9k/powerlevel9k"
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=500
SAVEHIST=500
DISABLE_AUTO_TITLE=true
DISABLE_UPDATE_PROMPT=true

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon user dir vcs node_version go_version rbenv) # kubecontext
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time battery)
OS_ICON=""
POWERLEVEL9K_RUBY_ICON="💎"
POWERLEVEL9K_GO_ICON="🐹"
POWERLEVEL9K_KUBERNETES_ICON="☸️ "
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"

plugins=(
  brew
  docker
  git
  kubectl
  rails
  # aws
  # tmux
  z
)

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

bindkey "\e\eOD" backward-word
bindkey "\e\eOC" forward-word

# Local provision file for zsh
source $HOME/.zshrc.local

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

# rbenv
eval "$(rbenv init - --no-rehash)"
