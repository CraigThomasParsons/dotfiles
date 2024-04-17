#!/usr/bin/env bash
# This script assumes you've cloned this repository to ~/dotfiles
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
(
  cd ~/.oh-my-zsh/themes
  ln -s ~/dotfiles/dracula/dracula.zsh-theme
)