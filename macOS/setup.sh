#!/bin/bash

printf "\n\n==================================================\n"
echo "STEP 1:"
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

# vim related files:
ln -s -f ~/workspace/dotfiles/macOS/.nvimrc ~/.config/nvim/init.vim
ln -s -f ~/workspace/dotfiles/macOS/.vimrc ~/.vimrc
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.bundles ~/.vimrc.bundles
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.commands ~/.vimrc.commands
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.mappings ~/.vimrc.mappings
ln -s -f ~/workspace/dotfiles/macOS/.vimrc.options ~/.vimrc.options

# zsh related files:
ln -s -f ~/workspace/dotfiles/macOS/.zshrc ~/.zshrc
ln -s -f ~/workspace/dotfiles/macOS/.zshrc.plugins ~/.zshrc.plugins
ln -s -f ~/workspace/dotfiles/macOS/themes/.zshrc.theme ~/.zshrc.theme
ln -s -f ~/workspace/dotfiles/macOS/themes/starship.toml ~/.config/starship.toml

printf "\nSymlinking complete!\n"

printf "\n\n==================================================\n"
echo "STEP 2:"
echo "homebrew setup..."
echo "=================================================="

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    printf "homebrew installation complete!\n"
else
    echo "Updating homebrew..."
    brew update
    printf "homebrew update complete!\n"
fi


printf "\n\n==================================================\n"
echo "STEP 3:"
echo "Installing homebrew packages..."
echo "=================================================="
brew bundle -v
printf "\nhomebrew packages installed!\n"


printf "\n\n==================================================\n"
echo "STEP 4:"
echo "oh-my-zsh setup..."
echo "=================================================="
if [ ! -d ~/.oh-my-zsh ]
then
  echo "Downloading oh-my-zsh..."
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  printf "Download complete!\n"
else
  printf "oh-my-zsh already setup...\n"
fi


printf "\n\n==================================================\n"
echo "STEP 5:"
echo "Default shell to zsh..."
echo "=================================================="
if [ "$(echo $SHELL)" = "/bin/zsh" ]
then
  printf "Your default shell is already zsh\n"
else
  echo "Changing your default shell to zsh..."
  chsh -s /bin/zsh
  printf "Your default shell is now zsh\n"
fi;


printf "\n\n==================================================\n"
echo "STEP 6:"
echo "Create a empty .env and .zshrc.local files"
echo "=================================================="
if [ ! -f ~/.env ]
then
  echo "Creating an empty file to place your ENV variables..."
  touch ~/.env
  printf "File created!\n"
else
  printf ".env file already present!\n"
fi

if [ ! -f ~/.zshrc.local ]
then
  echo "Creating an empty file to place your local zsh config..."
  touch ~/.zshrc.local
  printf "File created!\n"
else
  printf ".zshrc.local file already present!\n"
fi


printf "\n\n==================================================\n"
echo "STEP 7:"
echo "Install vim-plug for neovim"
echo "=================================================="

if [ ! -f ~/.config/nvim/autoload/plug.vim ]
then
  echo "Downloading vim-plug..."
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  printf "Download complete!\n"

  echo "Installing vim plugins..."
  nvim +PlugInstall +qall
  printf "Installation complete!\n"
else
  echo "vim-plug already installed!"
  nvim +PlugClean +PlugInstall +qall
  echo
fi

printf "\n\n==================================================\n"
echo "STEP 8:"
echo "Setting up rbenv"
echo "=================================================="

if [ -d ~/.rbenv ]
then
  echo "Setting up rbenv..."
  rbenv init
  printf "\nPlease restart your terminal\n"
else
  printf "rbenv already setup!\n"
fi
