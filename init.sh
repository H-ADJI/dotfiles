#!/bin/bash
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
sudo --validate
bash "$HOME/dotfiles/setup/$DISTRO/setup.sh"
