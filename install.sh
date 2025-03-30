#!/bin/bash

# Get the directory of the script (i.e., the parent directory of the script is the dotfiles folder)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup"

# Function to backup and symlink a config for a specific tool
backup_and_symlink() {
    local service="$1"
    local target_config="$CONFIG_DIR/$service"
    local source_config="$DOTFILES_DIR/.config/$service"

    # Check if the target config folder already exists
    if [ -d "$target_config" ]; then
        # Backup the current config folder
        echo "Backing up existing $service config to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target_config" "$BACKUP_DIR/"
    fi

    # Ensure parent directory exists
    mkdir -p "$CONFIG_DIR"

    # Create symlink from the dotfiles config to the user's config directory
    ln -s "$source_config" "$target_config"
    echo "Symlinked $service config from dotfiles."
}

install_node() {
  echo "Installing npm & n..."
  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s install lts
  sudo npm install -g n
  echo "Installed npm & n."
}

install_neovim() {
    echo "Installing Neovim..."

    # Deps
    install_node

    # Define installation paths
    NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    INSTALL_DIR="$HOME/.local"
    BIN_DIR="$INSTALL_DIR/bin"

    # Create necessary directories
    mkdir -p "$BIN_DIR"

    # Download and extract Neovim
    curl -L "$NVIM_URL" | tar xz -C "$INSTALL_DIR"

    # Ensure nvim is in the PATH
    ln -sf "$INSTALL_DIR/nvim-linux-x86_64/bin/nvim" "$BIN_DIR/nvim"

    # Add to PATH if not already present
    if ! echo "$PATH" | grep -q "$BIN_DIR"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    # Add alias for vim -> nvim
    if ! grep -q "alias vim='nvim'" "$HOME/.bashrc"; then
        echo "alias vim='nvim'" >> "$HOME/.bashrc"
    fi

    # Backup and symlink the Neovim config
    backup_and_symlink "nvim"

    # Install Packer plugin manager
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    # nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    # nvim --headless -c 'PackerSync'

    # ripgrep
    sudo apt-get install -y ripgrep

    # Neovim python env
    install_uv
    source "$HOME/.bashrc"
    uv venv --python 3.10 "$INSTALL_DIR/nvim-linux-x86_64/.venv"
    source "$INSTALL_DIR/nvim-linux-x86_64/.venv/bin/activate"
    uv pip install neovim


    echo "Neovim installed successfully! Restart your shell or run 'source ~/.bashrc' to update your PATH."
}

install_lazygit() {
  echo "Installing Lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Ls "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xz  
  mv lazygit "$HOME/.local/bin/"
  echo "Installed Lazygit."
}

install_kitty() {
    echo "Installing Kitty terminal..."

    # Run the official Kitty installer
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Backup and symlink the Kitty config
    backup_and_symlink "kitty"
    echo "Kitty installed successfully! Restart your shell or run 'source ~/.bashrc' to update your PATH and aliases."
}

install_uv() {
    if ! command -v uv &> /dev/null; then
        echo "uv not found, installing..."    
	curl -LsSf https://astral.sh/uv/install.sh | sh
        echo "uv installed successfully!"
    fi
}

# Main script menu
main_menu() {
    echo "Select what you want to install:"
    echo "1) Neovim "
    echo "2) Kitty"
    echo "3) Lazygit"
    echo "4) All"
    echo "5) Exit"

    read -p "Enter your choice [1-4]: " choice
    case "$choice" in
        1)
            install_neovim
            ;;
        2)
            install_kitty
            ;;
        3) 
            install_lazygit
            ;;
        4)
            install_neovim
            install_kitty
            ;;
        5)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            main_menu
            ;;
    esac
}
a
# Start the menu
main_menu
