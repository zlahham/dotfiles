# Prompt (starship). Minimal dir + git prompt. Inert in Warp (honor_ps1=false
# -> Warp draws its own); shows up in tmux / iTerm / ssh.
# Config: ~/.config/starship.toml.

command -v starship >/dev/null && eval "$(starship init zsh)"
