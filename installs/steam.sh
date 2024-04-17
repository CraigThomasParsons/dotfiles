#!/usr/bin/env bash
# This script assumes you have git installed
mkdir -p ~/.local/share/Steam/skins
(
  cd ~/.local/share/Steam/skins/
  git clone https://github.com/dracula/steam.git 'Dracula'
)

echo "open Steam and go to Steam -> Settings -> Preferences and open the section 'Interface'"
echo "select the skin Dracula and restart Steam, done!"
