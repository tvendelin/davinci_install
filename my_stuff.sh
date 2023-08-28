#!/bin/bash

# My things, no relation to DaVinci installation.
# Use as a template or ditch altogether.
sudo xbps-install -y \
    virtualbox-ose \
    transmission \
    cmake \
    python3-devel \
    fd \
    feh

# My ALSA config, system-specific.
# See https://docs.voidlinux.org/config/media/alsa.html
sudo cat <<EOI >> /etc/alsa.conf
defaults.ctl.card 1;
defaults.pcm.card 1;
EOI

# Keyboard layout toggling for multilingual users
sudo mkdir -p "/etc/X11/xorg.conf.d" && \
cat <<'EOI' >> /etc/X11/xorg.conf.d/30-keyboard.conf
Section "InputClass"
	Identifier "keyboard"
	MatchIsKeyboard "on"
	Option "XKbLayout" "us,de,ru"
	Option "XKbOptions" "grp:win_space_toggle"
EndSection
EOI

git clone https://github.com/tvendelin/dotfiles.git
for F in .bashrc .git .gitconfig .gitconfig-user .gitignore-global .vimrc; do
    cp "$HOME/dotfiles//$F" $HOME/
done

# feh key bindings (useful with fzf)
mkdir -p $HOME/.config/feh
cat <<EOI > $HOME/.config/feh/keys
zoom_in plus KP_Add equal
zoom_out minus KP_Subtract
quit Up Down Escape
EOI
