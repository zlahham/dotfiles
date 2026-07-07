# Sourced sidecar files: shared aliases/functions + machine-local secrets.
# (~/.zshrc.local — machine-local overrides — is sourced LAST, see 99-local.zsh.)

[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.env" ]     && source "$HOME/.env"
