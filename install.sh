#!/bin/bash

echo "🍻 Let's install some awesome dotfiles..."

# Work on home directory
cd ~

if [ ! "$(command -v fzf)" ] || [ ! "$(command -v bat)" ] || [ ! "$(command -v nvim)" ] || [ ! "$(command -v lsd)" ]; then
  echo "❌ Some of the following commands are not available: fzf, bat, nvim and lsd"
  exit 1
fi

if [ ! "$(command -v starship)" ]; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
  [[ $? -ne 0 ]] && echo '❌ starship installation failed' && exit 1
else
  echo '✅ starship already installed'
fi

RESPONSE="N"
read -rp '⚠️  Are you sure you want to delete the dotfiles and zshrc directories, and all their content? (Y/N) ' RESPONSE

if [ "$RESPONSE" == "Y" ]; then
	if [ -d .zsh ] && [ ! -L .zsh ]; then
		cp -r .zsh /tmp/zsh.bak
		echo "✅ Backed up .zsh directory to /tmp/zsh.bak"
	elif [ -L .zsh ] && [ -f .zsh/zshrc_custom ]; then
		cp .zsh/zshrc_custom /tmp/zshrc_custom.bak
		echo "✅ Backed up zshrc_custom to /tmp/zshrc_custom.bak"
	fi

	rm -rf .dotfiles
	git clone -b starship https://github.com/alejandrocq/dotfiles.git || (echo "Can't clone dotfiles repository ❌" && exit 1)
	mv dotfiles .dotfiles

	rm -rf .zshrc .zsh
	ln -s .dotfiles/zsh/zshrc .zshrc
	ln -s .dotfiles/zsh/ .zsh

	if [ -d /tmp/zsh.bak ]; then
		cp -r /tmp/zsh.bak/. .zsh/
		echo "✅ Restored .zsh directory contents"
	elif [ -f /tmp/zshrc_custom.bak ]; then
		cp /tmp/zshrc_custom.bak .zsh/zshrc_custom
		echo "✅ Restored zshrc_custom"
	fi

	mkdir -p .config/nvim/
	ln -s ~/.dotfiles/nvim/init.vim .config/nvim/init.vim
	ln -s ~/.dotfiles/starship/starship.toml .config/starship.toml

	echo "Installation completed! Enjoy 😁"
	exec zsh
else
	echo "Installation cancelled! 😕"
fi
