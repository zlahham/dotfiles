# ------------------------------------------------------------
#                         oh-my-zsh
# ------------------------------------------------------------
export TERM='xterm-256color'
export LANG=en_GB.UTF-8
export EDITOR="$(which nvim)"
export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/workspace/dotfiles/macOS"

HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=5000
SAVEHIST=5000
DISABLE_AUTO_TITLE=true

source $HOME/.zshrc.plugins
# source $HOME/.zsh.theme
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

bindkey "\e\eOD" backward-word
bindkey "\e\eOC" forward-word

# Local provision file for zsh
source $HOME/.zshrc.local

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory

# rbenv
eval "$(rbenv init -)"

# starship prompt
eval "$(starship init zsh)"

function iterm2_print_user_vars() {
  iterm2_set_user_var kubecontext "⎈ $(kubectl config current-context)"
  iterm2_set_user_var awsregion "☁️ $(aws configure get region)"
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

