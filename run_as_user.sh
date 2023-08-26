#!/bin/bash

git clone https://github.com/tvendelin/dotfiles.git
for F in .bashrc,.git,.gitconfig,.gitconfig-user,.gitignore-global,.vimrc; do
    cp "$HOME/dotfiles/gitconfig/$F" $HOME/
done

mkdir $HOME/suckless && cd $HOME/suckless

for R in st dwm dmenu slstatus; do
    git clone "https://git.suckless.org/$R" 
    cd $R
    sudo make clean install
    cd ..
done

cd $HOME

# feh key bindings (useful with fzf)
mkdir -p $HOME/.config/feh
cat <<EOI > $HOME/.config/feh/keys
zoom_in plus KP_Add equal
zoom_out minus KP_Subtract
quit Up Down Escape
EOI

cat <<EOI > $HOME/.xinitrc
/usr/local/bin/slstatus &
exec dwm
EOI
