# Path to your oh-my-zsh installation.
export TERM='xterm-256color'
export ZSH=$HOME/.oh-my-zsh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# I also like steeef, ys
ZSH_THEME="spaceship"

plugins=(apt git npm rails rbenv zsh-syntax-highlighting)


#initialize Z (https://github.com/rupa/z)
. ~/z.sh

source $ZSH/oh-my-zsh.sh

# Change window title of Terminal when using zsh
precmd () { print -Pn "\e]0;$TITLE\a" }
title() { export TITLE="$*" }

# ------------------------------------------------------------
#                         ZSH Settings
# ------------------------------------------------------------

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

source ~/.aliases

# ------------------------------------------------------------
#                      Env Variables
# ------------------------------------------------------------

source ~/.env

# ------------------------------------------------------------
#                         User Configuration
# ------------------------------------------------------------

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

alias ll='ls -lAFh'                         # Long ls implementation

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Elixir path
export PATH="$PATH:/usr/local/bin/elixir"

