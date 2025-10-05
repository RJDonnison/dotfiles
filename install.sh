#!/bin/zsh

echo "Installing packages..."

yay -S --needed - <yay.txt
grep -v '^$' flatpak.txt | xargs -I {} flatpak install -y {}

echo "Moving configs..."

CONFIGS=(ctpv kitty lazygit lf nvim rofi)
for cfg in "${CONFIGS[@]}"; do
  [ -d "$HOME/.config/$cfg" ] && mv "$HOME/.config/$cfg" "$HOME/.config/$cfg.bak"
  mv -p "$cfg" "$HOME/.config/$cfg"
done

[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
mv -p .zshrc "$HOME/.zshrc"

[ -f "$HOME/.p10k.zsh" ] && mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
mv -p .p10k.zsh "$HOME/.p10k.zsh"
