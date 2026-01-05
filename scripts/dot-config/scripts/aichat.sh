#!/usr/bin/env bash
file=$(mktemp --suffix=.md)
wl-paste --no-newline >"$file"
tmux new-window -n 'aichat output' "$EDITOR $file"
# tmux new-window -n:scrollback-edit "$EDITOR '+ normal G $' $file"
