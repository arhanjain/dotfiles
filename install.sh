#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# check if script running with root priviledges
if [ $(id -u) -ne 0 ]; then
  echo "Please run script with root priviledges."
  exit
fi

# use py venv if the person wants
# TODO: finish support
if ! command -v python3.10 &> /dev/null; then
  apt-get update
  apt-get install -y software-properties-common
  add-apt-repository -y ppa:deadsnakes/ppa
  apt-get install -y python3.10-venv

fi

python3.10 -m venv $SCRIPT_DIR/.dotfiles-venv
$SCRIPT_DIR/.dotfiles-venv/bin/pip install textual

$SCRIPT_DIR/.dotfiles-venv/bin/python $SCRIPT_DIR/installer/main.py

# use conda to run script
# if ! command -v conda &> /dev/null; then
#   mkdir -p $HOME/Downloads/
#   wget -O $HOME/Downloads/miniconda_installer.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#   bash $HOME/Downloads/miniconda_installer.sh -b -p $HOME/miniconda
#   
#   conda=$HOME/miniconda/bin/conda 
# 
#   $conda init bash
#   # eval "$($HOME/miniconda/bin/conda shell.bash hook)"
# 
#   $conda create -y -n dotfiles python=3.10 
# 
#  # conda activate dotfiles
#   $conda install -y -c conda-forge textual -n dotfiles
# 
# fi
