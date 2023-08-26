#!/bin/bash

usage(){
    cat <<EOU
    Installs Davinci Resolve 18.5.1 
    and dependencies on Void Linux / dwm desktop.
    Must be run with root rights.

    $0 <path/to/unzipped/davinci/installer>

    This script serves my personal needs/preferences.
    As these might be different from yours, 
    read the code and edit before running it.

EOU
}

DAVINCI_INSTALLER="$1"
if [ ! -x "$DAVINCI_INSTALLER" ]; then
    echo "Expecting path to Da Vinci installer"
    usage
fi

# Nvidia drivers come from here
xbps-install void-repo-nonfree xtools

# update everything
xbps-install -Su

xbps-install vim-huge git fzf fd tmux bash-completion lynx \
    xorg alsa-utils \
    base-devel libX11-devel libXft-devel libXinerama-devel \
    google-fonts-ttf \
    xkblayout-state \

    # DaVinci Resolve dependencies 
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
#    qt-devel
#    qt
#    Qt
    # libglvnd-devel

$DAVINCI_INSTALLER
    
# These point to outdated libs, 
# but the newer ones are already installed.
# So, just move them out of the way.
mkdir /opt/resolve/libs/_disabled
mv libgio-2.0.so* _disabled/
mv libglib-2.0.so* _disabled/
mv libgmodule-2.0.so* _disabled/
mv libgobject-2.0.so* _disabled/

# My things, no relation to DaVinci installation.
# Use as a template or ditch altogether.
xbps-install \
    virtualbox-ose \
    transmission \
    cmake \
    python3-devel \
    fd \
    feh

# My ALSA config, system-specific.
# See https://docs.voidlinux.org/config/media/alsa.html
cat <<EOI >> /etc/alsa.conf
defaults.ctl.card 1;
defaults.pcm.card 1;
EOI

# Keyboard layout toggling for multilingual users
cat <<'EOI' >> /etc/X11/xorg.conf.d/30-keyboard.conf
Section "InputClass"
	Identifier "keyboard"
	MatchIsKeyboard "on"
	Option "XKbLayout" "us,de,ru"
	Option "XKbOptions" "grp:win_space_toggle"
EndSection
EOI
