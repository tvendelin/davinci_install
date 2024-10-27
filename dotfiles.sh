#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

git clone https://github.com/tvendelin/dotfiles.git $HOME/dotfiles || true
for F in .bashrc .gitconfig .gitconfig-user .gitignore-global .vimrc .Xresources; do
    cp "$DOTFILES_DIR/$F" $HOME/
done

# feh key bindings (useful with fzf)
mkdir -p $HOME/.config/feh
cp -R "$DOTFILES_DIR/feh" "$HOME/.config/feh"
