#!/bin/zsh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
COLOR_DIR="$HOME/.local/share/color-schemes"
AURORAE_DIR="$HOME/.local/share/aurorae/themes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
KVANTUM_DIR="$HOME/.config/Kvantum"
FONT_DIR="$HOME/.local/share/fonts"
DESKTOP_DIR="/usr/share/applications/"

echo "[*] Installing packages..."

yay -S --needed - <yay.txt

gum confirm "Would you like to install flatpak apps" && grep -v '^$' flatpak.txt | xargs -I {} flatpak install -y {}

gun confirm "Would you like to configure bluetooth" && sudo systemctl start bluetooth && sudo systemctl enable --now bluetooth

echo "[*] Moving configs..."

CONFIGS=(ctpv kitty lazygit lf nvim rofi)
for cfg in "${CONFIGS[@]}"; do
  [ -d "$HOME/.config/$cfg" ] && mv "$HOME/.config/$cfg" "$HOME/.config/$cfg.bak"
  cp "$BASE_DIR/$cfg" "$HOME/.config/$cfg" && echo "Configured $cfg"
done

[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
cp .zshrc "$HOME/.zshrc" && echo "Configured zsh"

[ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
cp .p10k.zsh "$HOME/.p10k.zsh" && echo "Configured PowerLevel10k"

if [ -d "$base_dir/desktop" ]; then
    echo "[*] Copying desktop files..."
    for file in "$base_dir/desktop/"*; do
        if [ -f "$file" ]; then
            sudo cp "$file" "$desktop_dir/"
            echo "[*] Copied $(basename "$file")"
        fi
    done
    echo "[*] Desktop files configured."
else
    echo "[!] Desktop source directory not found: $base_dir/desktop"
fi

echo "[*] Installing Mystical-Blue (Jux) Theme..."

mkdir -p "$COLOR_DIR" "$AURORAE_DIR" "$PLASMA_DIR" "$KVANTUM_DIR" "$FONT_DIR"

cp "$BASE_DIR/JuxTheme.colors" "$COLOR_DIR/" && echo "[+] Installed color scheme: JuxTheme"
tar -xzf "$BASE_DIR/JuxDeco.tar.gz" -C "$AURORAE_DIR/" && echo "[+] Installed Aurorae decoration: JuxDeco"
tar -xzf "$BASE_DIR/JuxPlasma.tar.gz" -C "$PLASMA_DIR/" && echo "[+] Installed Plasma theme: JuxPlasma"

if [ -f "$BASE_DIR/NoMansSkyJux.tar.gz" ]; then
    tar -xzf "$BASE_DIR/NoMansSkyJux.tar.gz" -C "$KVANTUM_DIR/"
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
    fc-cache -fv > /dev/null
    echo "[+] JetBrainsMono fonts installed"
else
    echo "[=] JetBrainsMono already installed ($FONT_COUNT files)"
fi
