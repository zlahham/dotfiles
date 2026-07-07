# Zsh plugins (brew). Guarded so a missing install won't error.
# NOTE: syntax-highlighting must be sourced last — keep it the final block here.

_brew_share="/opt/homebrew/share"
[ -f "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$_brew_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$_brew_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _brew_share
