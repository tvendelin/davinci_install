#!/bin/bash -e

if [ "$(id -u)" != "0" ]; then
    echo "This script should be run by root"
    exit 1
fi;

# My things, no relation to DaVinci installation.
# Use as a template or ditch altogether.

# Patch and re-install dwm
cd dwm-6.5/
patch < ../patches/dwm-tvendelin-6.5.diff 
make clean install
cd ..

xbps-install -y \
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
    android-file-transfer-linux \
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
echo 'user_allow_other' >> /etc/fuse.conf

# Git prompt
ln -s /usr/share/git/git-prompt.sh /etc/bash/bashrc.d/

# FZF key bindings
ln -s /usr/share/fzf/completion.bash /etc/bash/bashrc.d/fzf_completion.sh
ln -s /usr/share/fzf/completion.bash /etc/profile.d/fzf_completion.sh
ln -s /usr/share/fzf/key-bindings.bash /etc/bash/bashrc.d/fzf_keybindings.sh
ln -s /usr/share/fzf/key-bindings.bash /etc/profile.d/fzf_keybindings.sh


# My ALSA config, system-specific.
# See https://docs.voidlinux.org/config/media/alsa.html
cat <<'EOI' > /etc/asound.conf 
defaults.ctl.card 1;
defaults.pcm.card 1;
EOI

# Keyboard layout toggling for multilingual users
sudo mkdir -p "/etc/X11/xorg.conf.d"
cat  <<EOI > /etc/X11/xorg.conf.d/30-keyboard.conf 
Section "InputClass"
	Identifier "keyboard"
	MatchIsKeyboard "on"
	Option "XKbLayout" "us,de,ru"
	Option "XKbOptions" "grp:win_space_toggle"
EndSection
EOI

# Personal devices.
# To configure yours,
# lsusb
# lsusb -v -s <bus>:<device>
# Follow the pattern

cat  <<EOI > /usr/lib/udev/rules.d/98-my_devices.rules
# NB! vendor/product IDs without leading 0x
# android 
SUBSYSTEMS=="usb", ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", GROUP="plugdev", MODE="0770", SYMLINK+="android%n"
# Sony camera
SUBSYSTEMS=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0cae", GROUP="plugdev", MODE="0774", SYMLINK+="sony%n"
# Zoom H5 recorder
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1686", ATTRS{idProduct}=="01c5", GROUP="plugdev", MODE="0770", SYMLINK+="zoomh5%n"
EOI

# Sony RX100M7 as a webcam
echo v4l2loopback > /etc/modules-load.d/v4l2loopback.conf 
modprobe v4l2loopback

cat  <<EOI > /local/bin/camera 
#!/bin/bash
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
EOI

chmod 0755 /usr/local/bin/camera 

