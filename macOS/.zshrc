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
ZSH_THEME="steeef"

plugins=(brew git npm rails tmux zsh-syntax-highlighting z)

source $ZSH/oh-my-zsh.sh
# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

alias ls='ls -GFh'
alias ll='ls -lAFh'                         # Long ls implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd: Makes new Dir and jumps inside
autoload -U zmv
alias mmv='noglob zmv -W'

alias ..='cd ../'                           # Go back 1 directory levels
alias .2='cd ../../'                        # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias path='echo -e ${PATH//:/\\n}'         # path: Echo all executable Paths
alias fix_stty='stty sane'                  # fix_stty: Restore terminal settings when screwed up
alias tree_less='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less' # This is similar to tree
alias zshconfig="vim ~/.zshrc"
alias sourcezsh="source ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias sourcevim="source ~/.vimrc"

#   ----------------------------------------------------------
#                        ENV VARIABLES
#   ----------------------------------------------------------

source ~/.env

#   ----------------------------------------------------------
#                         ZSH Settings
#   ----------------------------------------------------------

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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"

# ------------------------------------------------------------
#                      User Configuration
# ------------------------------------------------------------

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

eval "$(rbenv init -)"
