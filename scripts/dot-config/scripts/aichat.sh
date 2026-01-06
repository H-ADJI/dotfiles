#!/usr/bin/env bash
MSG_DIR="$HOME/.aichat/"
[ ! -d ~/.aichat ] && mkdir "$MSG_DIR"
file="$HOME/.aichat/$(basename "$(pwd)").md"
touch "$file"
echo >>"$file"
echo "---" >>"$file"
echo >>"$file"
wl-paste >>"$file"

tmux new-window -n 'aichat output' "$EDITOR $file"
