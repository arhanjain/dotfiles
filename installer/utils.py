import os, stat, subprocess, shutil
import requests
import pwd
import logging

from pathlib import Path

# Constants
USER = os.environ["SUDO_USER"]
HOME = pwd.getpwnam(USER).pw_dir
INSTALLER_DIR = Path(__file__).parent

def failed(program: str):
    logging.info(f"{program} failed to install. Please debug or file an issue at arhanjain/dotfiles")

def setup_neovim(installer_dir: Path,):

    # Install Neovim if not installed
    if not shutil.which("nvim"):
        #page_ref.log_text.appendleft(":monkey: Neovim not found. Installing Neovim...")
        logging.info("Neovim not found. Installing Neovim...")
        
        # Install appimage
        r = requests.get("https://github.com/neovim/neovim/releases/latest/download/nvim.appimage", stream=True)
        nvim_appimage_path = installer_dir/"nvim.appimage"
        f = open(nvim_appimage_path, "wb")
        f.write(r.content)
        f.close()
        
        # Extract appimage for systems that don't support appimage
        nvim_appimage_path.chmod(stat.S_IXUSR)
        subprocess.run([nvim_appimage_path, "--appimage-extract"], cwd=installer_dir, stdout=subprocess.DEVNULL)
        (installer_dir/"squashfs-root").rename("/opt/neovim")
        
        # Add binary to PATH
        Path("/usr/local/bin/nvim").symlink_to("/opt/neovim/AppRun")

        # Remove unnecessary files
        nvim_appimage_path.unlink()

        # Check if Neovim installed correctly
        if not shutil.which("nvim"):
            failed("Neovim")
            return
        else:
            pass
            logging.info("Neovim installed")
    else:
        pass
        logging.info("Neovim found.")
    
    logging.info("Setting up Neovim...")

    # Make config directory incase it doesnt exist
    if not Path(f"{HOME}/.config").exists():
        Path(f"{HOME}/.config").mkdir()

    # Check if Neovim config already exists, backup if it does
    nvim_config_path = Path(f"{HOME}/.config/nvim")
    if nvim_config_path.exists():
        logging.info("Neovim config directory already exists! Backing it up")
        nvim_config_path.rename(f"{nvim_config_path}.backup")

    # Link Neovim config to local config
    Path(f"{HOME}/.config/nvim").symlink_to(installer_dir/"../.config/nvim/")

    logging.info("Installing Neovim plugin dependencies...")

    # Install a bunch of plugin dependencies if they aren't already installed
    if not shutil.which("g++"):
        logging.info("Installing G++...")
        subprocess.run(["apt-get", "-y", "install", "g++"], stdout=subprocess.DEVNULL)

    if not shutil.which("npm"):
        if not shutil.which("curl"):
            logging.info("Installing curl...")
            subprocess.run(["apt-get", "-y", "install", "curl"], stdout=subprocess.DEVNULL)

        logging.info("Installing NodeJS...")
        node_curl = subprocess.run(["curl", "-fsSL", "https://deb.nodesource.com/setup_lts.x"], capture_output=True)
        subprocess.run(["sudo", "-E", "bash", "-"], input=node_curl.stdout, stdout=subprocess.DEVNULL)
        subprocess.run(["apt-get", "-y", "install", "nodejs"], stdout=subprocess.DEVNULL)

    if not shutil.which("pyright"):
        subprocess.run(["npm", "i", "--quiet", "--location=global", "pyright"], stdout=subprocess.DEVNULL)

    logging.info("Installing Neovim package manager (packer.nvim)")

    # Install packer.nvim
    if not Path(f"{HOME}/.local/share/nvim/site/pack/packer/opt/packer.nvim").exists():
        subprocess.run(["sudo", "-u", USER , "git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", f"{HOME}/.local/share/nvim/site/pack/packer/opt/packer.nvim"], stdout=subprocess.DEVNULL)

    # Compile Neovim plugins and sync
    logging.info("Installing Neovim plugins...")
    subprocess.run(["sudo", "-u", USER, "nvim", "-c", "autocmd User PackerComplete quitall", "-c", "PackerSync"], stdout=subprocess.DEVNULL)


if __name__ == "__main__":
    setup_neovim(Path("/home/ubuntu/dotfiles/installer"))

