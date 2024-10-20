#!/bin/bash

sudo xbps-install -y -Su xbps

# Nvidia drivers come from here
sudo xbps-install -y -Su void-repo-nonfree xtools

# update everything
sudo xbps-install -y -Su

sudo xbps-install -y vim-huge git tmux bash-completion lynx \
    xorg alsa-utils \
    base-devel libX11-devel libXft-devel libXinerama-devel \
    google-fonts-ttf \
    xkblayout-state 

# DaVinci Resolve dependencies
sudo xbps-install -y \
    nvidia \
    nvidia-opencl \
    libopencv \
    xcb-util  \
    xcb-util-wm \
    xcb-util-image \
    xcb-util-keysyms \
    xcb-util-renderutil \
    libxkbcommon-x11 \
    glu

# Install Suckless software,
# customize later
mkdir $HOME/suckless && cd $HOME/suckless

for R in st dwm dmenu slstatus; do
    git clone "https://git.suckless.org/$R"
    cd $R
    sudo make clean install
    cd ..
done

cd $HOME

cat <<EOI > $HOME/.xinitrc
xrdb -merge ~/.Xresources
/usr/local/bin/slstatus &
exec dwm
EOI

cat <<EOI > $HOME/.Xresources
! For "normal" monitors, set to 96
Xft.dpi: 192

Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
EOI
