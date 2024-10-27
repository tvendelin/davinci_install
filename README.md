# Install Davinci Resolve 18.5.1 on Void Linux

The assumptions is, you have not very ancient NVIDIA GPU as of 2023.  Still, even if not, things
should work out after a few fairly obvious modifications. 

The scripts should be run by a sudo-capable user in the following order:

```
sh void_install.sh
```

The system will reboot. Run `startx` to get GUI environment, download your copy of DaVinci Resolve,
and unzip it. Run

```
sh davinci_resolv_install.sh 
```

Launch DaVinci Resolve from DWM by typing `<Ctrl>-P`, and typing `resolve` in the text box.

### My Personal Setup

This is irrelevant to DaVinci Resolve installation, and partly is specific to my system. Please note
that the choice of CLI tools reflect my personal preferences, which may differ from yours.

```bash
# Install and configure system-wide
sudo ./my_stuff.sh

# Clone and install dotfiles
./dotfiles.sh
```

Feel free to peek, steal, modify, send pull requests, etc.
