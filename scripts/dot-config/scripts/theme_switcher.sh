#!/usr/bin/env sh
THEMES="dark\nlight"
SELECTED_THEME=$(echo -e "$THEMES" | fuzzel -d --lines=2 --width=20 -p "Select Theme: ")
CONFIG_DIR="$HOME/.config"
if [ -z "$SELECTED_THEME" ]; then
    echo "No theme selected. Exiting."
    exit 1
fi
# -------------------------------------------------------------------------------------
# ALACRITTY
ALACRITTY_CONF_DIR="$CONFIG_DIR/alacritty"
ALACRITTY_CONF_FILE="$ALACRITTY_CONF_DIR/alacritty.toml"
cp "$ALACRITTY_CONF_DIR/alacritty_$SELECTED_THEME.toml" "$ALACRITTY_CONF_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# NVIM
echo "$SELECTED_THEME" >"$HOME/.config/nvim/theme"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# waybar
WAYBAR_CONFIG_DIR="$CONFIG_DIR/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/theme.css"
cp "$WAYBAR_CONFIG_DIR/$SELECTED_THEME.css" "$WAYBAR_CONFIG_FILE"
killall -SIGUSR2 waybar
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# swaybg
BG_CONFIG_DIR="$CONFIG_DIR/assets"
BG_CONFIG_FILE="$BG_CONFIG_DIR/background"
cp "$BG_CONFIG_DIR/$SELECTED_THEME" "$BG_CONFIG_FILE"
sh "$HOME/.config/scripts/swaybg.sh"
