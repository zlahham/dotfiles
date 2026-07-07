# Line-editor keybindings. (fzf and rgv add their own later, after compinit.)

# Word navigation & deletion — works in Warp and inside tmux.
# Alt+Left/Right jump by word; Alt+Backspace/Delete kill a word.
bindkey "\e[1;3D" backward-word       # Alt+Left  (tmux/xterm sequence)
bindkey "\e[1;3C" forward-word        # Alt+Right (tmux/xterm sequence)
bindkey "\eb"     backward-word       # Esc-b fallback (Warp "Option as Meta")
bindkey "\ef"     forward-word        # Esc-f fallback
bindkey "^[^?"    backward-kill-word  # Alt+Backspace
bindkey "\e[3;3~" kill-word           # Alt+Delete (forward)
