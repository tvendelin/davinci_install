#!/bin/bash -e

sudo xbps-install -y -Su xbps

# Nvidia drivers come from here
sudo xbps-install -y -Su void-repo-nonfree xtools

# update everything
sudo xbps-install -y -Su

sudo xbps-install -y vim-huge git tmux bash-completion lynx \
    rxvt-unicode urxvt-perls  \
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

# Install Suckless software

curl -O https://dl.suckless.org/tools/slstatus-1.0.tar.gz
tar zxf slstatus-1.0.tar.gz
cd slstatus-1.0
sudo make clean install
cd ..

curl -O https://dl.suckless.org/tools/dmenu-5.3.tar.gz
tar zxf dmenu-5.3.tar.gz
cd dmenu-5.3
sudo make clean install
cd ..

curl -O https://dl.suckless.org/dwm/dwm-6.5.tar.gz 
tar zxf dwm-6.5.tar.gz 
cd dwm-6.5/
sudo make clean install
cd ..

# Minimal .Xresources, wrks for 32" monitor
# Easier to downscale than the opposite, with tiny text
cat <<EOI > $HOME/.Xresources
! For "normal" monitors, set to 96
!Xft.dpi: 96
Xft.dpi: 192

Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb

! Minimal urxvt configuration
URxvt*background: [90]#1E1E1E
URxvt*depth: 32
URxvt*foreground: #E6D4A3
URxvt.cursorColor: #EE0000

URxvt.iso14755: false
URxvt.iso14755_52: false
EOI

cat <<EOI > $HOME/.xinitrc
xrdb -merge ~/.Xresources
/usr/local/bin/slstatus &
exec dwm
EOI

