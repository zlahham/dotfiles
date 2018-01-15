#!/bin/bash

for pkg in git vim tmux zsh; do
  if brew list -1 | grep -q "^${pkg}\$"; then
    echo "Package '$pkg' is installed"
  else
    echo "Package '$pkg' is not installed"
    brew install $i;
  fi
done

echo "Symlinking your dotfiles to your home directory..."
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

if [ -f ~/.oh-my-zsh/custom/themes/steeef.zsh-theme ]
then
  ln -s -f ~/workspace/dotfiles/macOS/steeef.zsh-theme ~/.oh-my-zsh/custom/themes/steeef.zsh-theme
  echo "Your zsh theme has been changed to steeef"
  echo
else
  echo "Downloading oh-my-zsh..."
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  echo "Download complete!"
  echo
fi

if ! [ -f /bin/zsh ]
then
  echo "Changing your default shell to zsh..."
  chsh -s /bin/zsh
  echo "Your default shell is now zsh"
  echo
fi


if ! [ -f ~/z.sh ]
then
  echo "Downloading z.sh autocomplete for zsh..."
  wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/z.sh
  echo "Download complete!"
  echo
fi

if ! [ -f ~/.env ]
then
  echo "Creating an empty file to place your ENV variables..."
  touch ~/.env
  echo "File created!"
  echo
fi

if ! [ -d ~/.vim/bundle/Vundle.vim ]
then
  echo "Downloading Vundle..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo "Download complete!"
  echo

  echo "Installing vim plugins..."
  vim +PluginInstall +qall
  echo "Installation complete!"
  echo
fi

# if ! [ -f /usr/share/fonts/Droid_Sans_Mono_for_Powerline.otf ]
# then
#   echo "Adding Droid Sans Mono for powerline to your fonts..."
#   sudo cp ~/workspace/dotfiles/Droid_Sans_Mono_for_Powerline.otf /usr/share/fonts/Droid_Sans_Mono_for_Powerline.otf
#   echo "Please restart your terminal and select this font from the preferences of your favourite Terminal"
#   echo
# fi

if ! [ -d ~/.rbenv ]
then
  echo "Downloading rbenv..."
  brew update
  brew install rbenv
  echo "Download complete! visit https://github.com/rbenv/rbenv for more info on setting up rbenv."
  echo

  echo "Please restart your terminal"
  echo
fi

if ! [ -d ~/.tmux/plugins/tpm ]
then
  echo "Downloading tpm..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "Download complete!"
  echo

  echo "Please restart your terminal"
  echo
fi
