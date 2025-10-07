# KDE plasma config

This is my [Endeavour OS](https://endeavouros.com) with [KDE Plasma](https://kde.org/plasma-desktop/) system configs.

## Installation

The provided install script will install all the packages in `yay.txt`, it will also provide the option
to install all flatpak apps in `flatpak.txt`. It will also configure the system with the theme and
general settings.

1. Clone the repo `git clone https://github.com/RJDonnison/dotfiles.git`
2. Make `install.sh` executable with `chmod +x install.sh`
3. Install system `./install.sh`
4. Enjoy :)

## Apps

I am using a number of apps on my system that will install, mainly kitty for a terminal,
lf for my file manager, [LazyVim](https://www.lazyvim.org) as my text editor, and rofi
as a app launcher.

## Theme

The system theme is largely the [Mystical Blue Theme](https://github.com/juxtopposed/Mystical-Blue-Theme) with some minor changes.
Icons are from [Yet Another Monochrome Icon Set](https://store.kde.org/p/2303161) with some custom icons for apps that were missing them.
The font used in the system is [JetBrainsMono](https://www.jetbrains.com/lp/mono/)

## ROADMAP

- [x] icons
- [x] custom desktop files
- [x] panel
- [ ] kwin scripts
- [x] keybinds
