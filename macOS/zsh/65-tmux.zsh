# tmux session management via tmuxinator.
#
# Sessions are declarative: one project file per session in
# ~/.config/tmuxinator/<name>.yml. Those files are machine-local and NOT
# tracked in this repo — which repos exist differs per box. setup.sh only
# creates the empty dir, same treatment as ~/.env and ~/.zshrc.local.
#
#   tmuxinator start <name>   one session, attach
#   tmux-up                   every session, attach once
#
# tmuxinator comes from `gem install tmuxinator` on the asdf ruby, not brew —
# the brew formula hard-depends on brew's own ruby. That means it lives in the
# current asdf ruby only: after `asdf install ruby <new>`, reinstall the gem
# and `asdf reshim ruby`, or the command vanishes. Hence the guard below.
#
# Needs compinit (40-completion.zsh) for the completion at the bottom.

command -v tmuxinator >/dev/null 2>&1 || return

# tmuxinator 3.4 ships only the `tmuxinator` binary, not the `mux` short form.
alias mux='tmuxinator'

# tmux-up [project...] — bring up every tmuxinator project (or only the named
# ones) and attach.
#
# `tmuxinator start` takes a single project and attaches to it, so there is no
# native way to raise the whole set. Loop it detached and attach once at the
# end. Sessions that are already running are skipped rather than restarted, so
# re-running is a no-op — safe from a cold boot or from inside tmux.
#
# Session name is assumed to match the project filename, which is the
# convention every file in ~/.config/tmuxinator/ follows.
tmux-up() {
  local project
  local -a projects
  if (( $# )); then
    projects=("$@")
  else
    projects=(${(f)"$(tmuxinator completions start)"})
  fi

  # Fresh machine: setup.sh made the dir but there are no projects in it yet.
  if (( ! ${#projects} )); then
    print -u2 "tmux-up: no projects in ~/.config/tmuxinator — create one with 'tmuxinator new <name>'"
    return 1
  fi

  for project in $projects; do
    if tmux has-session -t "=$project" 2>/dev/null; then
      print "tmux-up: $project already running"
    elif ! tmuxinator start "$project" --no-attach; then
      print -u2 "tmux-up: failed to start $project"
    fi
  done

  # Only attach from outside tmux; nesting a client inside a session is a mess.
  [[ -n $TMUX ]] || tmux attach
}

_tmux_up() { compadd -- ${(f)"$(tmuxinator completions start)"} }
compdef _tmux_up tmux-up
