#!/bin/bash

echo "🍻 Let's install some awesome dotfiles..."

# Work on home directory
cd ~

if [ ! "$(command -v fzf)" ] || [ ! "$(command -v bat)" ] || [ ! "$(command -v nvim)" ] || [ ! "$(command -v lsd)" ]; then
  echo "❌ Some of the following commands are not available: fzf, bat, nvim and lsd"
  exit 1
fi

[[ -d .oh-my-zsh ]] && echo '✅ oh-my-zsh already installed' || CHSH=yes RUNZSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
[[ $? -ne 0 ]] && echo '❌ oh-my-zsh installation failed' && exit 1

[[ -e .p10k.zsh ]] && echo '✅ powerlevel10k already installed' || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
[[ $? -ne 0 ]] && echo '❌ powerlevel10k installation failed' && exit 1

RESPONSE="N"
read -rp '⚠️  Are you sure you want to delete the dotfiles and zshrc directories, and all their content? (Y/N) ' RESPONSE

if [ "$RESPONSE" == "Y" ]; then
	rm -rf .dotfiles
	git clone https://github.com/alejandrocq/dotfiles.git || (echo "Can't clone dotfiles repository ❌" && exit 1)
	mv dotfiles .dotfiles

	rm -rf .zshrc .zsh
	ln -s .dotfiles/zsh/zshrc .zshrc
	ln -s .dotfiles/zsh/ .zsh
	ln -s .dotfiles/zsh/p10k.zsh .p10k.zsh

	mkdir -p .config/nvim/
	ln -s ~/.dotfiles/nvim/init.vim .config/nvim/init.vim

	echo "Installation completed! Enjoy 😁"
	exec zsh
else
	echo "Installation cancelled! 😕"
fi
