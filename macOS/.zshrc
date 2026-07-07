# ------------------------------------------------------------
#                    zsh loader (keep this thin)
# ------------------------------------------------------------
# Real config lives in ~/.config/zsh/*.zsh (this repo: macOS/zsh/), one concern
# per file. Fragments are sourced in filename order; the numeric prefixes ARE
# the load order (globs expand alphabetically):
#
#   00-env  10-history  20-sources  30-keybindings  40-completion
#   50-plugins  60-fzf  70-prompt  99-local
#
# Rules: low = early, high = late; step by 10 so a new concern slots in without
# renumbering. Edit the fragments, not this file. Ordering that matters:
# 40-completion before 50-plugins/60-fzf; syntax-highlighting last in plugins;
# 99-local last of all.
for _frag in "$HOME/.config/zsh/"*.zsh(N); do
  source "$_frag"
done
unset _frag
