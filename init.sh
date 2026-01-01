#!/bin/bash
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles
cd dotfiles || exit 1
sudo --validate
bash "$HOME/dotfiles/setup/$DISTRO/setup.sh"
