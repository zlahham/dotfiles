# tmux session management via tmuxinator.
#
# Sessions are declarative: one project file per session in
# macOS/tmuxinator/*.yml, symlinked to ~/.config/tmuxinator by setup.sh. A
# fresh machine gets the same set of sessions the moment setup.sh has run.
#
#   tmuxinator start <name>   one session, attach
#   tup                       every session, attach once
#
# Needs compinit (40-completion.zsh) for the completion below.

command -v tmuxinator >/dev/null 2>&1 || return

# The gem ships this alias but the brew formula doesn't link it.
alias mux='tmuxinator'

# tup [project...] — bring up every tmuxinator project (or only the named
# ones) and attach.
#
# `tmuxinator start` takes a single project and attaches to it, so there is no
# native way to raise the whole set. Loop it detached and attach once at the
# end. Sessions that are already running are skipped rather than restarted, so
# re-running is a no-op — safe from a cold boot or from inside tmux.
#
# Session name is assumed to match the project filename, which is the
# convention every file in macOS/tmuxinator/ follows.
tup() {
  local project
  local -a projects
  if (( $# )); then
    projects=("$@")
  else
    projects=(${(f)"$(tmuxinator completions start)"})
  fi

  for project in $projects; do
    if tmux has-session -t "=$project" 2>/dev/null; then
      print "tup: $project already running"
    elif ! tmuxinator start "$project" --no-attach; then
      print -u2 "tup: failed to start $project"
    fi
  done

  # Only attach from outside tmux; nesting a client inside a session is a mess.
  [[ -n $TMUX ]] || tmux attach
}

_tup() { compadd -- ${(f)"$(tmuxinator completions start)"} }
compdef _tup tup
