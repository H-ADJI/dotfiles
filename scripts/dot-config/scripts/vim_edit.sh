#!/bin/bash

file=$(mktemp)
tmux capture-pane -pS - >$file
tmux new-window -n:scrollback-edit "$EDITOR '+ normal G $' $file"
