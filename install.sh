#!/bin/sh
echo "🍻 Let's install some awesome dotfiles..."
cd ~

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "oh-my-zsh installation complete ✅"

rm -rf .dotfiles
git clone https://github.com/alejandrocq/dotfiles.git
mv dotfiles .dotfiles

rm -rf .zshrc .zsh
ln -s .dotfiles/zsh/zshrc .zshrc
ln -s .dotfiles/zsh/ .zsh

echo "Installation complete! Enjoy 😁"
