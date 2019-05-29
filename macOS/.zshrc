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
. /usr/local/etc/profile.d/z.sh

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
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon user dir_writable dir vcs virtualenv node_version)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time root_indicator background_jobs time battery)
POWERLEVEL9K_ROOT_ICON="\uF09C"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
# POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=true

plugins=(
  brew
  docker
  git
  aws
  # rails
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

# pyenv
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# jenv
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
