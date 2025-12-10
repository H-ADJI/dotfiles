#!/usr/bin/env bash
THEMES="dark\nlight"
ALLOWED_THEMES="dark / light"
CONFIG_DIR="$HOME/.config"
if [ -n "$1" ]; then
    SELECTED_THEME="$1"
else
    SELECTED_THEME=$(echo -e "$THEMES" | fuzzel -d --lines=2 --width=20 -p "Select Theme: ")
fi

SELECTED_THEME=$(echo "$SELECTED_THEME" | xargs)
if [ -z "$SELECTED_THEME" ]; then
    echo "No theme selected. Exiting."
    exit 1
fi

if ! echo "$ALLOWED_THEMES" | grep -qw "$SELECTED_THEME"; then
    echo "Invalid theme: $SELECTED_THEME. Allowed values are: $ALLOWED_THEMES"
    exit 1
fi
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# System color-scheme preference
gsettings set org.gnome.desktop.interface color-scheme "prefer-$SELECTED_THEME"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# yazi
YAZI_CONF_DIR="$CONFIG_DIR/yazi"
YAZI_CONF_FILE="$YAZI_CONF_DIR/theme.toml"
cp "$YAZI_CONF_DIR/$SELECTED_THEME" "$YAZI_CONF_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# bat
BAT_CONF_DIR="$CONFIG_DIR/bat"
BAT_CONF_FILE="$BAT_CONF_DIR/bat.conf"
cp "$BAT_CONF_DIR/$SELECTED_THEME" "$BAT_CONF_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# starship
STARSHIP_CONF_DIR="$CONFIG_DIR"
STARSHIP_CONF_FILE="$STARSHIP_CONF_DIR/starship.toml"
cp "$STARSHIP_CONF_DIR/$SELECTED_THEME.toml" "$STARSHIP_CONF_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# ALACRITTY
ALACRITTY_CONF_DIR="$CONFIG_DIR/alacritty"
ALACRITTY_CONF_FILE="$ALACRITTY_CONF_DIR/alacritty.toml"
cp "$ALACRITTY_CONF_DIR/$SELECTED_THEME.toml" "$ALACRITTY_CONF_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# NVIM
echo "$SELECTED_THEME" >"$HOME/.config/nvim/theme"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# fuzzel
FUZZEL_CONFIG_DIR="$CONFIG_DIR/fuzzel"
FUZZEL_CONFIG_FILE="$FUZZEL_CONFIG_DIR/fuzzel.ini"
cp "$FUZZEL_CONFIG_DIR/$SELECTED_THEME" "$FUZZEL_CONFIG_FILE"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# swaybg
BG_CONFIG_DIR="$CONFIG_DIR/assets"
BG_CONFIG_FILE="$BG_CONFIG_DIR/background"
cp "$BG_CONFIG_DIR/$SELECTED_THEME" "$BG_CONFIG_FILE"
sh "$HOME/.config/scripts/swaybg.sh"
# -------------------------------------------------------------------------------------
#
# -------------------------------------------------------------------------------------
# waybar
WAYBAR_CONFIG_DIR="$CONFIG_DIR/waybar"
WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/theme.css"
cp "$WAYBAR_CONFIG_DIR/$SELECTED_THEME.css" "$WAYBAR_CONFIG_FILE"
killall -SIGUSR2 waybar 
