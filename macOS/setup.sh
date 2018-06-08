#!/bin/bash

# STEP 1: Install homebrew
echo "=================================================="
echo "STEP 1:"
echo "Installing homebrew..."
echo "=================================================="

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo
echo "homebrew installation complete!"
echo

# STEP 2: Install homebrew formulae
echo "=================================================="
echo "STEP 2:"
echo "Installing homebrew packages..."
echo "=================================================="

for pkg in git vim tmux zsh wget reattach-to-user-namespace ctags the_silver_searcher htop z rbenv; do
  if brew list -1 | grep -q "^${pkg}\$"; then
    echo "Package '$pkg' is installed"
  else
    echo "Package '$pkg' is not installed"
    brew install $i;
  fi
done

echo
echo "homebrew packages installed!"
echo

# STEP 3: Symlink dotfiles
echo "=================================================="
echo "STEP 3:"
echo "Symlinking your dotfiles to your home directory..."
echo "=================================================="
ln -s -f ~/workspace/dotfiles/macOS/.aliases ~/.aliases
ln -s -f ~/workspace/dotfiles/macOS/.ctags ~/.ctags
ln -s -f ~/workspace/dotfiles/macOS/.gemrc ~/.gemrc
ln -s -f ~/workspace/dotfiles/macOS/.gitconfig ~/.gitconfig
ln -s -f ~/workspace/dotfiles/macOS/.gitignore_global ~/.gitignore_global
ln -s -f ~/workspace/dotfiles/macOS/.pryrc ~/.pryrc
ln -s -f ~/workspace/dotfiles/macOS/.rspec ~/.rspec
ln -s -f ~/workspace/dotfiles/macOS/.rubocop.yml ~/.rubocop.yml
ln -s -f ~/workspace/dotfiles/macOS/.tmux.conf ~/.tmux.conf
ln -s -f ~/workspace/dotfiles/macOS/.vimrc ~/.vimrc
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.bundles ~/.vimrc.bundles
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.commands ~/.vimrc.commands
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.mappings ~/.vimrc.mappings
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.options ~/.vimrc.options
ln -s -f ~/workspace/dotfiles/macOS/.zshrc ~/.zshrc

echo
echo "Symlinking complete!"
echo

# STEP 4: Install oh-my-zsh
echo "=================================================="
echo "STEP 4:"
echo "oh-my-zsh setup..."
echo "=================================================="

if ![ -f ~/.oh-my-zsh ]
then
  echo "Downloading oh-my-zsh..."
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "Download complete!"
else
  echo "oh-my-zsh already setup..."
fi
echo

# STEP 5: Install Custom oh-my-zsh Spaceship theme
echo "=================================================="
echo "STEP 5:"
echo "Install Spaceship theme for zsh"
echo "=================================================="

if ![ -f ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme ]
then
  curl -o - https://raw.githubusercontent.com/denysdovhan/spaceship-zsh-theme/master/install.zsh | zsh
  echo "Your zsh theme has been changed to Spaceship"
else
  echo "Spaceship already installed"
fi
echo

# STEP 6: Change default shell to zsh
echo "=================================================="
echo "STEP 6:"
echo "Default shell to zsh..."
echo "=================================================="

if ! [ -f /bin/zsh ]
then
  echo "Changing your default shell to zsh..."
  chsh -s /bin/zsh
  echo "Your default shell is now zsh"
else
  echo "Your default shell is already zsh"
fi
echo

# STEP 7: Create an empty .env file
echo "=================================================="
echo "STEP 7:"
echo "Create an empty .env file"
echo "=================================================="

if ! [ -f ~/.env ]
then
  echo "Creating an empty file to place your ENV variables..."
  touch ~/.env
  echo "File created!"
else
  echo ".env file already present!"
fi
echo

# STEP 8: Install Vundle package manager for vim
echo "=================================================="
echo "STEP 7:"
echo "Install Vundle for vim"
echo "=================================================="

if ! [ -d ~/.vim/bundle/Vundle.vim ]
then
  echo "Downloading Vundle..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo "Download complete!"
  echo

  echo "Installing vim plugins..."
  vim +PluginInstall +qall
  echo "Installation complete!"
else
  echo "Vundle installed!"
  vim +PluginClean +qall
fi
echo

# STEP 8: Add custom fonts
echo "=================================================="
echo "STEP 8:"
echo "Adding custom fonts to Font Book"
echo "=================================================="

if ! [ -f ~/Library/Fonts/Droid_Sans_Mono_for_Powerline.otf ] &&  [ -f ~/Library/Fonts/FiraCode-Retina.ttf ]
then
  echo "Adding Droid Sans Mono & Fira Code to your fonts..."
  sudo cp ~/workspace/dotfiles/fonts/Droid_Sans_Mono_for_Powerline.otf ~/Library/Fonts/Droid_Sans_Mono_for_Powerline.otf
  sudo cp ~/workspace/dotfiles/fonts/FiraCode-Retina.ttf ~/Library/Fonts/FiraCode-Retina.ttf
  echo "Please restart your terminal and select this font from the preferences of your favourite Terminal"
else
  echo "Fonts already added!"
fi
echo

# STEP 9: Setup rbenv
echo "=================================================="
echo "STEP 9:"
echo "Setting up rbenv"
echo "=================================================="

if [ -d ~/.rbenv ]
then
  echo "Setting up rbenv..."
  rbenv init
  echo
  echo "Please restart your terminal"
else
  echo "rbenv already setup!"
fi
echo

# STEP 10: Install Tmux package manager tpm
echo "=================================================="
echo "STEP 10:"
echo "Setting up rbenv"
echo "=================================================="

if ! [ -d ~/.tmux/plugins/tpm ]
then
  echo "Downloading tpm..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "Download complete!"
  echo "Please start a tmux session and enter CTRL-A + I to install the packages"
else
  echo "tpm already installed!"
fi
echo
