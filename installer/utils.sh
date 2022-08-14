#!/bin/bash

# Script path
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# User Home Directory
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

# Install paths
nvim_config_path="$USER_HOME/.config/nvim"
zshrc_path="$USER_HOME/.zshrc"

check_root_permissions() {
  if [ $(id -u) -ne 0 ]; then
    echo "Please run script with root priviledges."
    exit
  fi
}

# Call if anything failed
failed () {
  echo "$1 setup failed. Please debug installation or file an issue at arhanjain/dotfiles"
}

setup_nvim ()  {
  check_root_permissions

  # Install nvim binary
  if ! command -v nvim &> /dev/null; then
    echo "Neovim not found."
    echo "Installing Neovim..."
    wget -q -P "$SCRIPT_DIR/" "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage" > /dev/null
    chmod +x "$SCRIPT_DIR/nvim.appimage"
    "$SCRIPT_DIR/nvim.appimage" --appimage-extract > /dev/null
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

  # Check if Neovim config alread exists, backup if it does
  if [[ -d "$nvim_config_path" || -L "$nvim_config_path" ]]; then
    echo "Neovim config directory already exists! Backing it up"
    mv "$nvim_config_path" "$nvim_config_path.backup"
  fi
  mkdir -p "$USER_HOME/.config"
  ln -s "$SCRIPT_DIR/../.config/nvim" "$nvim_config_path"

  echo "Installing Neovim plugin dependencies..."

  # Neovim plugin dependencies installed
  if ! command -v g++ &> /dev/null; then
    echo "Installing G++..."
    apt-get -y install g++ > /dev/null
  fi

  if ! command -v npm &> /dev/null; then
    echo "Installing NodeJS..."

    if ! command -v curl &> /dev/null; then
      echo "Installing curl ..."
      apt-get -y install curl > /dev/null
    fi

    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - > /dev/null
    apt-get install -y nodejs > /dev/null
  fi

  echo "Installing pyright..."
  npm i -g pyright > /dev/null --quiet


  echo "Installing packer.nvim..."
  if [[ ! -d $USER_HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim ]]; then
    sudo -u $SUDO_USER git clone --depth=1 https://github.com/wbthomason/packer.nvim $USER_HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim
  fi

  # Compile Neovim plugins and sync
  echo "Installing Neovim plugins..."
  sudo -u $SUDO_USER nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"

  mv "$SCRIPT_DIR/../.config/nvim/lua/config/treesitter-backup.lua" "$SCRIPT_DIR/../.config/nvim/lua/config/treesitter.lua"

  echo "Finished Neovim setup!"
}

setup_zshrc () {
  echo "Setting up .zshrc..."
  if [[ -d "$zshrc_path" || -L "$zshrc_path" ]]; then
    echo ".zshrc file already exists!"
    failed .zshrc
  else
    ln -s "$SCRIPT_DIR/../.zshrc" "$zshrc_path"
    echo "Created symbolic link at $zshrc_path"
  fi
} 

$1
