# KDE plasma config

This is my [Endeavour OS](https://endeavouros.com) with [KDE Plasma](https://kde.org/plasma-desktop/) system configs.

## Installation

The provided install script will install all the packages in `yay.txt`, it will also provide the option
to install all flatpak apps in `flatpak.txt`. It will configure the system and install the theme.

1. Clone the repo `git clone https://github.com/RJDonnison/dotfiles.git`
2. Make `install.sh` executable with `chmod +x install.sh`
3. Install system `./install.sh`
4. set icons, colors, plasma style, window deco, enable better blur in settings
5. set active kvantum theme in kvantum manager
6. set application style as kvantum theme in settings
7. Enjoy :)

## Apps

I am using a number of apps on my system that will install, mainly kitty for a terminal,
lf for my file manager, [LazyVim](https://www.lazyvim.org) as my text editor, and rofi
as a app launcher.

## Theme

The system theme is largely the [Mystical Blue Theme](https://github.com/juxtopposed/Mystical-Blue-Theme) with some minor changes.
Icons are from [Yet Another Monochrome Icon Set](https://store.kde.org/p/2303161) with some custom icons for apps that were missing them.
The font used in the system is [JetBrainsMono](https://www.jetbrains.com/lp/mono/)

## ROADMAP

- [ ] panel - instructions
- [x] add .oh-my-zsh.sh - install
- [ ] kwin scripts
- [x] keybinds - use export
- [x] install desktops correct - install
- [ ] add option to remove unused apps - install
- [ ] add wallpaper
