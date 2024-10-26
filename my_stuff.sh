#!/bin/bash

# My things, no relation to DaVinci installation.
# Use as a template or ditch altogether.
sudo xbps-install -y \
    rxvt-unicode urxvt-perls  \
    git \
    bash-completion \
    psmisc \
    fzf \
    fd \
    feh \

    cups \
    hplip-gui \

    cmake \
    python3-devel \

    simple-mtpfs \
    fuse3 \
    gparted \
    android-file-transfer \

    gphoto2 \
    v4l2loopback  \
    screenkey  \
    ffmpeg \
    audacity  \

    kodi \
    mpv \
    virtualbox-ose \
    transmission \
    firefox

# Fuse3
mv /etc/fuse.conf /etc/orig.fuse.conf
echo 'user_allow_other' | sudo tee -a /etc/fuse.conf

# FZF key bindings
ln -s /usr/share/fzf/completion.bash /etc/bash/bashrc.d/fzf_completion.sh
ln -s /usr/share/fzf/completion.bash /etc/profile.d/fzf_completion.sh
ln -s /usr/share/fzf/key-bindings.bash /etc/bash/bashrc.d/fzf_keybindings.sh
ln -s /usr/share/fzf/key-bindings.bash /etc/profile.d/fzf_keybindings.sh


# My ALSA config, system-specific.
# See https://docs.voidlinux.org/config/media/alsa.html
sudo tee /etc/asound.conf > /dev/null <<'EOI'
defaults.ctl.card 1;
defaults.pcm.card 1;
EOI

# Keyboard layout toggling for multilingual users
sudo mkdir -p "/etc/X11/xorg.conf.d"
sudo tee /etc/X11/xorg.conf.d/30-keyboard.conf > /dev/null <<EOI
Section "InputClass"
	Identifier "keyboard"
	MatchIsKeyboard "on"
	Option "XKbLayout" "us,de,ru"
	Option "XKbOptions" "grp:win_space_toggle"
EndSection
EOI

git clone https://github.com/tvendelin/dotfiles.git $HOME/dotfiles || true
for F in .bashrc .git .gitconfig .gitconfig-user .gitignore-global .vimrc .Xresources; do
    cp "$HOME/dotfiles/$F" $HOME/
done

# feh key bindings (useful with fzf)
mkdir -p $HOME/.config/feh
cat <<EOI > $HOME/.config/feh/keys
zoom_in plus KP_Add equal
zoom_out minus KP_Subtract
quit Up Down Escape
EOI

# Sony RX100M7 as a webcam
echo v4l2loopback | sudo tee /etc/modules-load.d/v4l2loopback.conf >/dev/null
sudo modprobe v4l2loopback

sudo tee /usr/local/bin/camera > /dev/null <<EOI
#!/bin/bash
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
EOI

sudo chmod 0755 /usr/local/bin/camera 

# Personal devices
# To configure yours,
# lsusb
# lsusb -v -s <bus>:<device>
# NB! vendor/product IDs without leading 0x

sudo tee /usr/lib/udev/rules.d/98-my_devices.rules <<EOI
# android 
#
SUBSYSTEMS=="usb", ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", GROUP="plugdev", MODE="0770", SYMLINK+="android%n"
# Sony camera
#
SUBSYSTEMS=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0cae", GROUP="plugdev", MODE="0774", SYMLINK+="sony%n"
# Zoom H5 recorder
# 
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1686", ATTRS{idProduct}=="01c5", GROUP="plugdev", MODE="0770", SYMLINK+="zoomh5%n"
EOI
