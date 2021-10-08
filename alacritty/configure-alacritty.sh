#!/bin/zsh -l

alacritty_config_file="$HOME/.config/alacritty/alacritty.yml"
mkdir -p "$(dirname "$alacritty_config_file")"
{
    cat <<EOF
import:
  - $DOTFILE_DIR/theme/$DESKTOP_THEME/alacritty.yml

EOF
cat "$DOTFILE_DIR/alacritty/alacritty.yml"
} > "$alacritty_config_file"
