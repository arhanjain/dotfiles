#!/bin/bash

# install conda
if ! command -v conda &> /dev/null; then
  mkdir -p $HOME/Downloads/
  wget -O $HOME/Downloads/miniconda_installer.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash $HOME/Downloads/miniconda_installer.sh -b -p $HOME/miniconda
  
  $HOME/miniconda/bin/conda init bash
  eval "$($HOME/miniconda/bin/conda shell.bash hook)"

  conda create -y -n dotfiles python=3.10 
  conda activate dotfiles
  conda install -y -c conda-forge textual

fi
