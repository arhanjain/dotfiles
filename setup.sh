#!/bin/bash

# Script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# Install paths
nvim_config_path="$HOME/.config/nvim"
zshrc_path="$HOME/.zshrc"

failed () {
  echo "$1 setup failed."
}

setup_nvim ()  {
  echo "Setting up Neovim..."
  if [ -d "$nvim_config_path" ]; then
    echo "Neovim config directory already exists!"
    failed Neovim
  else
    mkdir -p "$HOME/.config"
    ln -s "$SCRIPT_DIR/.config/nvim" "$nvim_config_path"
    echo "Created symbolic link at $nvim_config_path"
  fi
}

setup_zshrc () {
  echo "Setting up .zshrc..."
  if [ -d "$zshrc_path" ]; then
    echo ".zshrc file already exists!"
    failed .zshrc
  else
    ln -s "$SCRIPT_DIR/.zshrc" "$zshrc_path"
    echo "Created symbolic link at $zshrc_path"
  fi
} 

if [ -z $1 ]; then
  echo "Usage: ./setup.sh [all, nvim, etc]"
fi

if [ "$1" = "all" ]; then

  echo "Configuring all..."
fi


if [ "$1" = "nvim" ]; then
  setup_nvim
fi

# eventually make this set up all zsh (Pure prompt, zsh itself, etc)
if [ "$1" = "zshrc" ]; then
  setup_zshrc
fi

