# fzf (fuzzy finder). Sourced after compinit so fzf's completion registers.
# Ctrl-R fuzzy history, Ctrl-T fuzzy file insert, Alt-C fuzzy cd. ripgrep backs
# the file lists (honours .gitignore, includes hidden, skips .git).

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
