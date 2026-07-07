# ------------------------------------------------------------
#                         Shell
# ------------------------------------------------------------
# Don't hardcode TERM: tmux sets it to tmux-256color inside a session and Warp
# sets it outside. Forcing xterm-256color inside tmux breaks screen redraws
# (ghosted content, half-drawn pane borders). Only fall back if truly unset.
[ -z "$TERM" ] && export TERM='xterm-256color'
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

# ------------------------------------------------------------
#                        ENV VARIABLES
# ------------------------------------------------------------

source $HOME/.env

# ------------------------------------------------------------
#                      User Configuration
# ------------------------------------------------------------


# Word navigation & deletion — works in Warp and inside tmux.
# Alt+Left/Right jump by word; Alt+Backspace/Delete kill a word.
bindkey "\e[1;3D" backward-word       # Alt+Left  (tmux/xterm sequence)
bindkey "\e[1;3C" forward-word        # Alt+Right (tmux/xterm sequence)
bindkey "\eb"     backward-word       # Esc-b fallback (Warp "Option as Meta")
bindkey "\ef"     forward-word        # Esc-f fallback
bindkey "^[^?"    backward-kill-word  # Alt+Backspace
bindkey "\e[3;3~" kill-word           # Alt+Delete (forward)

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
#                      Completion
# ------------------------------------------------------------
# oh-my-zsh used to run compinit; do it ourselves now. Must run before the
# plugins below. -C skips the slow security audit (brew dirs are trusted).
autoload -Uz compinit && compinit -C
zmodload zsh/complist
zstyle ':completion:*' menu select                      # arrow-key selectable menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colourise the menu

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
