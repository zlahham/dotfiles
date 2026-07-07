#!/bin/bash
# macOS dotfiles setup. Safe to re-run (idempotent).
#
# By default runs every step. Use flags to skip parts:
#   --links-only   only symlink dotfiles (skip brew/shell/nvim/asdf)
#   --no-links     skip the symlink step
#   --no-brew      skip Homebrew install/update, Warp, and `brew bundle`
#   --no-bundle    run brew + Warp, but skip `brew bundle` (the heavy installs)
#   --no-shell     don't change the default shell (skip chsh)
#   --no-nvim      skip the neovim plugin sync
#   --no-asdf      skip asdf plugin setup
#   --no-tmux      skip tmux plugin (tpm) install
#   -h, --help     show this and exit
#
# Examples:
#   bash macOS/setup.sh --no-bundle       # everything but the 13 brew installs
#   bash macOS/setup.sh --links-only      # just refresh symlinks
set -uo pipefail

DOTFILES="$HOME/workspace/dotfiles"
MAC="$DOTFILES/macOS"

# ---- helpers --------------------------------------------------------
banner() {
  printf "\n\n==================================================\n"
  printf "STEP %s:\n%s\n" "$1" "$2"
  printf "==================================================\n"
}

# Idempotent symlink: skips missing sources, never nests into an existing dir.
link() {
  local src="$1" dest="$2"
  if [ ! -e "$src" ]; then
    printf "  ! source missing, skipped: %s\n" "$src"
    return
  fi
  if [ -d "$dest" ] && [ ! -L "$dest" ]; then
    rm -rf "$dest"   # a real dir would make ln nest inside it
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"   # -n: replace a symlink-to-dir instead of following it
  printf "  linked %s\n" "$dest"
}

# Load Homebrew into this shell (Apple Silicon).
load_brew() {
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
}

usage() { sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; }

# ---- flags (default: do everything) ---------------------------------
DO_LINKS=1 DO_BREW=1 DO_BUNDLE=1 DO_SHELL=1 DO_ENV=1 DO_NVIM=1 DO_ASDF=1 DO_TMUX=1

while [ $# -gt 0 ]; do
  case "$1" in
    --links-only) DO_BREW=0; DO_BUNDLE=0; DO_SHELL=0; DO_ENV=0; DO_NVIM=0; DO_ASDF=0; DO_TMUX=0 ;;
    --no-links)   DO_LINKS=0 ;;
    --no-brew)    DO_BREW=0; DO_BUNDLE=0 ;;
    --no-bundle)  DO_BUNDLE=0 ;;
    --no-shell)   DO_SHELL=0 ;;
    --no-nvim)    DO_NVIM=0 ;;
    --no-asdf)    DO_ASDF=0 ;;
    --no-tmux)    DO_TMUX=0 ;;
    -h|--help)    usage; exit 0 ;;
    *) echo "unknown flag: $1" >&2; echo >&2; usage >&2; exit 1 ;;
  esac
  shift
done

# ---- sanity ---------------------------------------------------------
if [ "$(uname)" != "Darwin" ]; then
  echo "This is the macOS setup; you're on $(uname). Aborting." >&2
  exit 1
fi
if [ ! -d "$MAC" ]; then
  echo "Expected repo at $DOTFILES but it's not there. Clone it there first." >&2
  exit 1
fi

# Make brew available for any step that needs it, regardless of flags.
load_brew


if [ "$DO_LINKS" = 1 ]; then
  banner 1 "Symlinking your dotfiles to your home directory..."
  link "$MAC/.aliases"          "$HOME/.aliases"
  link "$MAC/.gemrc"            "$HOME/.gemrc"
  link "$MAC/.gitconfig"        "$HOME/.gitconfig"
  link "$MAC/.gitignore_global" "$HOME/.gitignore_global"
  link "$MAC/.rspec"            "$HOME/.rspec"
  link "$MAC/.tmux.conf"        "$HOME/.tmux.conf"

  # neovim: the whole config dir is symlinked (init.lua + lua/plugins/*).
  link "$MAC/nvim"              "$HOME/.config/nvim"

  # zsh (no oh-my-zsh; plugins are sourced directly from .zshrc)
  link "$MAC/.zshrc"               "$HOME/.zshrc"
  link "$MAC/themes/starship.toml" "$HOME/.config/starship.toml"

  # Warp terminal config
  link "$MAC/warp/settings.toml"                   "$HOME/.warp/settings.toml"
  link "$MAC/warp/user_preferences.yaml"           "$HOME/.warp/user_preferences.yaml"
  link "$MAC/warp/tab_configs/startup_config.toml" "$HOME/.warp/tab_configs/startup_config.toml"
  link "$MAC/warp/themes/revie_night.yaml"         "$HOME/.warp/themes/revie_night.yaml"

  # Claude Code
  link "$MAC/claude/settings.json"         "$HOME/.claude/settings.json"
  link "$MAC/claude/scripts/statusline.py" "$HOME/.claude/scripts/statusline.py"
  printf "\nSymlinking complete!\n"
fi


if [ "$DO_BREW" = 1 ]; then
  banner 2 "Homebrew setup..."
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_brew
  fi
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew still not on PATH — cannot continue with brew steps." >&2
    exit 1
  fi
  echo "Updating homebrew..."
  brew update || true

  banner 3 "Installing Warp terminal (early, so it's ready to use)..."
  if [ -d "/Applications/Warp.app" ]; then
    printf "Warp already installed.\n"
  else
    echo "Installing Warp..."
    brew install --cask warp || echo "  (Warp install failed — check output above)"
  fi
fi


if [ "$DO_BREW" = 1 ] && [ "$DO_BUNDLE" = 1 ]; then
  banner 4 "Installing homebrew packages..."
  brew bundle --file="$MAC/Brewfile" -v || \
    echo "  (brew bundle reported errors — check output above)"
fi


if [ "$DO_SHELL" = 1 ]; then
  banner 5 "Default shell to zsh..."
  if [ "$SHELL" = "/bin/zsh" ]; then
    printf "Default shell is already zsh.\n"
  else
    echo "Changing your default shell to zsh (may prompt for your password)..."
    chsh -s /bin/zsh || printf "  chsh failed — set it manually: chsh -s /bin/zsh\n"
  fi
fi


if [ "$DO_ENV" = 1 ]; then
  banner 6 "Create empty ~/.env and ~/.zshrc.local (for secrets / machine-local config)"
  [ -f "$HOME/.env" ]         || { touch "$HOME/.env";         echo "  created ~/.env"; }
  [ -f "$HOME/.zshrc.local" ] || { touch "$HOME/.zshrc.local"; echo "  created ~/.zshrc.local"; }
  printf "Done.\n"
fi


if [ "$DO_NVIM" = 1 ]; then
  banner 7 "Install neovim plugins (lazy.nvim)"
  if command -v nvim >/dev/null 2>&1; then
    # lazy.nvim + treesitter (main branch) bootstrap from init.lua. The sync also
    # runs each plugin's build step (treesitter's is ":TSUpdate"), so parsers are
    # installed here too. Safe to re-run.
    echo "Syncing neovim plugins (and treesitter parsers)..."
    nvim --headless "+Lazy! sync" +qa || echo "  (nvim sync reported errors — open nvim and run :Lazy)"
    printf "Installation complete!\n"
  else
    printf "nvim not found (did brew bundle succeed?) — skipping plugin sync.\n"
  fi
fi


if [ "$DO_ASDF" = 1 ]; then
  banner 8 "Setting up asdf (version manager)"
  # asdf is installed by `brew bundle`; shell hooks live in .zshrc. Here we just
  # add the language plugins so `asdf install ruby latest` works.
  if command -v asdf >/dev/null 2>&1; then
    echo "Adding asdf plugins (ruby, nodejs)..."
    asdf plugin add ruby   2>/dev/null || true
    asdf plugin add nodejs 2>/dev/null || true
    printf "\nasdf plugins ready. Install a runtime, e.g.:\n"
    printf "  asdf install ruby latest && asdf set -u ruby latest\n"
    printf "  gem install ruby-lsp   # enables the neovim ruby LSP\n"
  else
    printf "asdf not found — ensure 'brew \"asdf\"' is in the Brewfile, then restart your shell.\n"
  fi
fi

if [ "$DO_TMUX" = 1 ]; then
  banner 9 "Installing tmux plugins (tpm)"
  if ! command -v tmux >/dev/null 2>&1; then
    printf "tmux not found — skipping.\n"
  else
    # Clone tpm if missing.
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
    # Install the plugins headlessly. install_plugins needs a running server that
    # sourced the config (to read @plugin vars), so only do this when no tmux
    # server is already running — never disturb a live session.
    if tmux info >/dev/null 2>&1; then
      printf "A tmux server is already running — install plugins in it with 'prefix + I'.\n"
    else
      tmux new-session -d -s __setup 2>/dev/null
      "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 \
        && printf "tmux plugins installed.\n" \
        || printf "  (tmux plugin install had issues — open tmux and run 'prefix + I')\n"
      tmux kill-server 2>/dev/null
    fi
  fi
fi

printf "\n\nDone. Restart your terminal (or 'exec zsh') to load everything.\n"
