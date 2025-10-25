#!/bin/bash

# Script to create a new conda environment 'devtools' in ~/envs
# and install required packages

# Source conda.sh to ensure 'conda activate' works inside the script
source /opt/conda/etc/profile.d/conda.sh

ENV_PATH="~/envs/devtools"
ENV_PATH_EXPANDED="$HOME/envs/devtools"  # for checking actual directory

echo "=== Creating conda environment at: $ENV_PATH (if it doesn't exist) ==="
if [ ! -d "$ENV_PATH_EXPANDED" ]; then
  conda create -p "$ENV_PATH" -y
else
  echo "Conda environment already exists at $ENV_PATH"
fi

echo "=== Activating conda environment ==="
conda activate "$ENV_PATH"

echo "=== Installing packages (git, zsh, vim, tmux, curl) from conda-forge ==="
conda install -c conda-forge git zsh vim tmux curl -y

echo "=== Done ==="
echo "You are now inside the conda environment at: $ENV_PATH"
echo ""
echo "To activate this environment later, run:"
echo "  conda activate $ENV_PATH"
echo ""
echo "=== Working on JupyterHub ==="
echo "To make conda activation work consistently, run:"
echo "  chmod +x setup-wo-sudo.sh && ./setup-wo-sudo.sh"
echo "  conda init bash && source ~/.bashrc && conda activate $ENV_PATH"