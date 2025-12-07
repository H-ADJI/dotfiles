#!/usr/bin/env sh
THEMES="dark\nlight"
SELECTED_THEME=$(echo -e "$THEMES" | fuzzel -d -p "Select Theme: ")
CONFIG_DIR="$HOME/.config"
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
