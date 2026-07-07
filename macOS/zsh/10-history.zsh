# History: persistent, sizeable, deduped. Not shared between panes (deliberate).

HISTFILE="$HOME/.zsh_history"   # oh-my-zsh used to set this; keep history persistent
HISTSIZE=50000
SAVEHIST=50000

# Do not share history between tmux windows
setopt noincappendhistory
setopt nosharehistory
# Keep history lean and useful (dedupe, drop leading-space cmds, timestamp)
setopt hist_ignore_all_dups   # a new dup drops the older copy
setopt hist_ignore_space      # a leading space keeps a command out of history
setopt hist_reduce_blanks     # collapse superfluous whitespace
setopt extended_history       # record start time + duration per entry
