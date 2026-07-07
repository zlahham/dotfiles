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
HISTSIZE=50000
SAVEHIST=50000
DISABLE_AUTO_TITLE=true

# ------------------------------------------------------------
#                         Aliases
# ------------------------------------------------------------

[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# ------------------------------------------------------------
#                        ENV VARIABLES
# ------------------------------------------------------------

[ -f "$HOME/.env" ] && source "$HOME/.env"

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

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory
# Keep history lean and useful (dedupe, drop leading-space cmds, timestamp)
setopt hist_ignore_all_dups   # a new dup drops the older copy
setopt hist_ignore_space      # a leading space keeps a command out of history
setopt hist_reduce_blanks     # collapse superfluous whitespace
setopt extended_history       # record start time + duration per entry

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
#                      fzf (fuzzy finder)
# ------------------------------------------------------------
# Ctrl-R fuzzy history, Ctrl-T fuzzy file insert, Alt-C fuzzy cd. Sourced
# after compinit so fzf's completion registers. ripgrep backs the file lists
# (honours .gitignore, includes hidden, skips .git).
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
  source <(fzf --zsh)

  # Interactive project-wide full-text search — the shell analog of nvim's `\`
  # (fzf-lua live_grep). Type to grep file *contents* live; Enter opens the
  # match in $EDITOR at the right line. Bound to Ctrl-G ("grep"); also `rgv`.
  rgv() {
    local rg="rg --column --line-number --no-heading --color=always --smart-case --hidden --glob !.git"
    local out
    out=$(: | fzf --ansi --disabled --query "${*:-}" \
      --bind "start:reload:$rg {q} || true" \
      --bind "change:reload:sleep 0.1; $rg {q} || true" \
      --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window 'up,60%,+{2}+3/3') || return
    local file=${out%%:*} line=${${(s.:.)out}[2]}
    [[ -n $file ]] && ${EDITOR:-nvim} +"$line" -- "$file"
  }
  # Ctrl-G runs it from the prompt, then redraws the command line afterwards.
  _rgv_widget() { rgv; zle reset-prompt; }
  zle -N _rgv_widget
  bindkey '^G' _rgv_widget
fi

# ------------------------------------------------------------
#                      Prompt (starship)
# ------------------------------------------------------------
# Minimal dir + git prompt. Inert in Warp (honor_ps1=false -> Warp draws its
# own); shows up in tmux / iTerm / ssh. Config: ~/.config/starship.toml.
command -v starship >/dev/null && eval "$(starship init zsh)"
