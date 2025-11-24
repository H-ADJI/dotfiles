#!/bin/zsh
sessions=(
    "dots"
    "scraping"
    "scraping_cli"
)

for SESSION in "${sessions[@]}"; do
    tmuxp load -yd "$SESSION"
done
