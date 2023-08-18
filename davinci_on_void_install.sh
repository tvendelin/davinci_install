#!/bin/bash

# Nvidia drivers come from here
xbps-install void-repo-nonfree xtools

# update everything
xbps-install -Su

xbps-install vim-huge git fzf fd tmux bash-completion lynx \
    xorg alsa-utils \
    base-devel libX11-devel libXft-devel libXinerama-devel \
    google-fonts-ttf \
    xkblayout-state \

    # Needed for DaVinci Resolv installer 
    nvidia \
    nvidia-opencl \
    libopencv \
    xcb-util  \
    xcb-util-wm \
    xcb-util-image \
    xcb-util-keysyms \
    xcb-util-renderutil \
    libxkbcommon-x11 \
    glu \
#    qt-devel
#    qt
#    Qt
    # libglvnd-devel
    

# My things, no relation to DaVinci installation
xbps-install \
    virtualbox-ose \
    transmission \
    cmake \
    python3-devel \
    fd 

# Keyboard layout toggling for multilingual users
cat <<'EOI' >> /etc/X11/xorg.conf.d/30-keyboard.conf
Section "InputClass"
	Identifier "keyboard"
	MatchIsKeyboard "on"
	Option "XKbLayout" "us,de,ru"
	Option "XKbOptions" "grp:win_space_toggle"
EndSection
EOI
