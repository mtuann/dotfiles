#!/bin/bash

# Script to create a new conda environment 'devtools' and install required packages

# Source conda.sh to ensure 'conda activate' works inside the script
source /opt/conda/etc/profile.d/conda.sh

ENV_NAME="devtools"

echo "=== Creating conda environment: $ENV_NAME (if it doesn't exist) ==="
conda env list | grep -q "^$ENV_NAME\s" || conda create -n $ENV_NAME -y

echo "=== Activating conda environment: $ENV_NAME ==="
conda activate $ENV_NAME

echo "=== Installing packages (git, zsh, vim, tmux, curl) from conda-forge ==="
conda install -c conda-forge git zsh vim tmux curl -y

echo "=== Done ==="
echo "You are now inside the conda environment: $ENV_NAME"
echo "To activate this environment later, run: conda activate $ENV_NAME"

echo "=== Working on JupyterHub ==="
echo "To activate this environment later, run: conda init bash && source ~/.bashrc && conda activate devtools"

