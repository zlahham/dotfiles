# Completion system. MUST run before 50-plugins.zsh and 60-fzf.zsh.

# oh-my-zsh used to run compinit; do it ourselves now. -C skips the slow
# security audit (brew dirs are trusted).
autoload -Uz compinit && compinit -C
zmodload zsh/complist
zstyle ':completion:*' menu select                      # arrow-key selectable menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colourise the menu
