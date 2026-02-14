#!/usr/bin/env bash
MSG_DIR="$HOME/.aichat/"
tmp_file=$(mktemp --suffix=.md)
[ ! -d ~/.aichat ] && mkdir "$MSG_DIR"
file="$HOME/.aichat/$(basename "$(pwd)").md"
touch "$file"
echo >>"$file"
echo "---" >>"$file"
echo >>"$file"
wl-paste >>"$file"

wl-paste >>"$tmp_file"

tmux new-window -n 'aichat output' "$EDITOR $tmp_file"
