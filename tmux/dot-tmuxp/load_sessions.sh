#!/bin/zsh
sessions=(
    "dots"
)

for SESSION in "${sessions[@]}"; do
    tmuxp load -yd "$SESSION"
done
