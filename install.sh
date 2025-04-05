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

    if command -v nvim &>/dev/null; then
        echo "Neovim is already installed."
        return 0
    fi
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

  if command -v lazygit &>/dev/null; then
      echo "Lazygit is already installed."
      return 0
  fi
  echo "Installing Lazygit..."

  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Ls "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xz  
  mv lazygit "$HOME/.local/bin/"
  echo "Installed Lazygit."
}

install_kitty() {

    if [[ -d "$HOME/.local/kitty.app" ]]; then
        echo "Kitty is already installed."
        return 0
    fi
    echo "Installing Kitty terminal..."

    # Run the official Kitty installer
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
    # your system-wide PATH)
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
    # Place the kitty.desktop file somewhere it can be found by the OS
    cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
    cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
    # Update the paths to the kitty and its icon in the kitty desktop file(s)
    sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
    sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
    # Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
    echo 'kitty.desktop' > ~/.config/xdg-terminals.list

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

install_zsh() {
    echo "Setting up ZSH..."

    # Check if Zsh is installed
    if ! command -v zsh &>/dev/null; then
        echo "Zsh is not installed. Installing..."
        if [[ "$(uname)" == "Darwin" ]]; then
            brew install zsh
        elif [[ "$(uname)" == "Linux" ]]; then
            sudo apt update && sudo apt install -y zsh
        else
            echo "Unsupported OS for Zsh installation."
            return 1
        fi
    else
        echo "Zsh is already installed."
    fi

    # Set Zsh as the default shell
    if [[ "$SHELL" != "$(command -v zsh)" ]]; then
        echo "Changing default shell to Zsh..."
        chsh -s "$(command -v zsh)"
    fi

    ZSHRC="$HOME/.zshrc"
     if [[ -f "$ZSHRC" ]]; then
        mv "$ZSHRC" "$HOME/.zshrc.back"
        echo "Backed up existing .zshrc to .zshrc.back"
    fi

    ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

    # Theme
    curl -sS https://starship.rs/install.sh | sh

    # Install Zap (Zsh plugin manager)
    if [[ ! -d "$HOME/.zap" ]]; then
        echo "Installing Zap..."
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) -k --branch release-v1
    else
        echo "Zap is already installed."
    fi
    
}

confirm_platform() {
    local platform
    if [[ "$(uname)" == "Darwin" ]]; then
        platform="macOS"
        platform_code=0
    elif [[ "$(uname)" == "Linux" ]]; then
        platform="Linux"
        platform_code=1
    else
        echo "Unsupported platform: $(uname)"
        return 2
    fi

    echo "Detected platform: $platform"
    read -p "Do you want to continue? (y/N) " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            echo "Proceeding..."
            return $platform_code
            ;;
        *)  
            echo "Aborted."
            return 2
            ;;
    esac
}


# Main script menu
main_menu() {
    confirm_platform
    platform_code=$?

    if [[ $platform_code -eq 0 ]]; then
        # Mac Case
        echo "this is not implemented yet!"
    elif [[ $platform_code -eq 1 ]]; then
        # Linux Case
        install_uv
        install_neovim
        install_kitty
        install_lazygit
        install_zsh
    else
        echo "Exiting due to unsupported platform or user cancellation."
        exit 1
    fi
}

# Start the menu
main_menu
