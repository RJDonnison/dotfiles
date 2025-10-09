#!/bin/bash

set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COLOR_DIR="$HOME/.local/share/color-schemes"
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
KVANTUM_DIR="$HOME/.config/Kvantum"
FONT_DIR="$HOME/.local/share/fonts"
DESKTOP_DIR="/usr/share/applications/"
ICONS_DIR="$HOME/.local/share/icons"

echo "[*] Installing packages..."

yay -S --needed - <"$BASE_DIR/yay.txt"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[*] Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattende
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  fi

  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/plugins}/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/plugins}/zsh-syntax-highlighting"
  fi

  echo "[+] zsh installed"d
fi

gum confirm "Would you like to install flatpak apps?" && grep -v '^$' "$BASE_DIR/flatpak.txt" | xargs -I {} flatpak install -y {}

gum confirm "Would you like to configure bluetooth?" && sudo systemctl start bluetooth && sudo systemctl enable --now bluetooth

echo "[*] Moving configs..."

for cfg in "$BASE_DIR/config/"*; do
  file=$(basename "$cfg")
  [ -d "$HOME/.config/$file" ] && mv "$BASE_DIR/config/$file" "$HOME/.config/$file.bak"
  cp -r "$BASE_DIR/config/$file" "$HOME/.config/$file" && echo "[+] Configured $file"
done

[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
cp -r .zshrc "$HOME/.zshrc" && echo "[+] Configured zsh"

[ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
cp -r .p10k.zsh "$HOME/.p10k.zsh" && echo "[+] Configured PowerLevel10k"

if [ -d "$BASE_DIR/desktop" ]; then
  echo "[*] Copying desktop files..."
  for file in "$BASE_DIR/desktop/"*; do
    filename=$(basename "$file")
    if [ -f "$BASE_DIR/desktop/$filename" ]; then
      sudo cp -r "$BASE_DIR/desktop/$filename" "$desktop_dir/"
      echo "[*] Copied $(basename "$file")"
    fi
  done
  echo "[*] Desktop files configured."
else
  echo "[!] Desktop source directory not found: $base_dir/desktop"
fi

echo "[*] Installing Mystical-Blue (Jux) Theme..."

mkdir -p "$COLOR_DIR" "$AURORAE_DIR" "$PLASMA_DIR" "$KVANTUM_DIR" "$FONT_DIR"

cp "$BASE_DIR/theme/JuxTheme.colors" "$COLOR_DIR/" && echo "[+] Installed color scheme: JuxTheme"
tar -xzf "$BASE_DIR/theme/JuxDeco.tar.gz" -C "$AURORAE_DIR/" && echo "[+] Installed Aurorae decoration: JuxDeco"
tar -xzf "$BASE_DIR/theme/JuxPlasma.tar.gz" -C "$PLASMA_DIR/" && echo "[+] Installed Plasma theme: JuxPlasma"

if [ -f "$BASE_DIR/theme/NoMansSkyJux.tar.gz" ]; then
  tar -xzf "$BASE_DIR/theme/NoMansSkyJux.tar.gz" -C "$KVANTUM_DIR/"
  echo "[+] Installed Kvantum theme: NoMansSkyJux"
fi

echo "[*] Checking JetBrainsMono fonts..."
FONT_COUNT=$(fc-list | grep -i "JetBrainsMono" | wc -l)

if [ "$FONT_COUNT" -lt 20 ]; then
  echo "[!] JetBrainsMono incomplete ($FONT_COUNT fonts found). Installing full set..."
  LOCAL_FONT_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "JetBrainsMono-*")
  if [ -n "$LOCAL_FONT_DIR" ]; then
    echo "[*] Installing from local: $LOCAL_FONT_DIR"
    find "$LOCAL_FONT_DIR" -type f -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
  else
    echo "[*] Downloading JetBrainsMono from JetBrains..."
    TMP_FONT=$(mktemp -d)
    wget -qO "$TMP_FONT/JetBrainsMono.zip" "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
    unzip -qq "$TMP_FONT/JetBrainsMono.zip" -d "$TMP_FONT"
    find "$TMP_FONT" -type f -name "*.ttf" -exec cp {} "$FONT_DIR/" \;
  fi
  fc-cache -fv >/dev/null
  echo "[+] JetBrainsMono fonts installed"
else
  echo "[=] JetBrainsMono already installed ($FONT_COUNT files)"
fi

echo "[*] Installing icons..."

mkdir -p "$ICONS_DIR"

tar -xzf "$BASE_DIR/theme/YAMIS.tar.gz" -C "$ICONS_DIR/" && echo "[+] Installed Icons: YAMIS"

echo "[+] Installed icons"

gum confirm "Would you like to remove unneeded apps?" && xargs -a "$BASE_DIR/remove.txt" yay -Rns
echo "[+] System installed"
