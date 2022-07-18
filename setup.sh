#!/bin/bash

# Script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


# Install paths
nvim_config_path="$HOME/.config/nvim"
zshrc_path="$HOME/.zshrc"

failed () {
  echo "$1 setup failed. Please debug installation or file an issue at arhanjain/dotfiles"
}

setup_nvim ()  {
  if ! command -v nvim &> /dev/null; then
    echo "Neovim not found."
    echo "Installing Neovim..."
    wget -P "$SCRIPT_DIR/" "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
    chmod +x "$SCRIPT_DIR/nvim.appimage"
    "$SCRIPT_DIR/nvim.appimage" --appimage-extract
    mv "$PWD/squashfs-root/" /opt/neovim/
    ln -s /opt/neovim/AppRun /usr/bin/nvim

    if ! command -v nvim &> /dev/null; then
      failed Neovim
      return
    else
      rm "$SCRIPT_DIR/nvim.appimage"
      echo "Neovim installed"
    fi
  else
    echo "Neovim found."
  fi

  echo "Setting up Neovim..."

  if [ -d "$nvim_config_path" ]; then
    echo "Neovim config directory already exists!"
    failed Neovim
  else
    mkdir -p "$HOME/.config"
    ln -s "$SCRIPT_DIR/.config/nvim" "$nvim_config_path"
  fi

  echo "Installing Neovim plugin dependencies..."

  if ! command -v g++ &> /dev/null; then
    echo "Installing G++..."
    sudo apt install g++
  fi

  if ! command -v npm &> /dev/null; then
    echo "Installing NodeJS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi

  echo "Installing pyright..."
  npm i -g pyright

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

