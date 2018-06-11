# Path to your oh-my-zsh installation.
export TERM='xterm-256color'
export ZSH=~/.oh-my-zsh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

. `brew --prefix`/etc/profile.d/z.sh

# I like: 'dst', 'ys', 'steeef'
ZSH_THEME="spaceship"

plugins=(brew git npm rails tmux zsh-syntax-highlighting z)

source $ZSH/oh-my-zsh.sh
# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

source ~/.aliases

#   ----------------------------------------------------------
#                        ENV VARIABLES
#   ----------------------------------------------------------

source ~/.env
export SSH_KEY_PATH="~/.ssh/dsa_id"
export NVM_DIR="$HOME/.nvm"

#   ----------------------------------------------------------
#                         ZSH Settings
#   ----------------------------------------------------------

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ------------------------------------------------------------
#                      User Configuration
# ------------------------------------------------------------

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

eval "$(rbenv init -)"

# Local provision file for zsh
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
