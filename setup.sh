#!/bin/bash

set -e

# Detect OS and install packages
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  echo "Detected macOS"
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install git zsh vim tmux
elif [[ -f /etc/debian_version ]]; then
  # Ubuntu/Debian
  echo "Detected Ubuntu/Debian"
  sudo apt update
  sudo apt install -y git zsh vim tmux
else
  echo "Unsupported OS. Please install git, zsh, vim, and tmux manually."
  exit 1
fi

# Clone dotfiles repo if not already present
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles from GitHub..."
  git clone https://github.com/mtuann/dotfiles.git "$DOTFILES_DIR"
fi

# Copy dotfiles to home directory
for file in .bashrc .vimrc .zshrc .tmux.conf .gitconfig; do
  if [ -f "$DOTFILES_DIR/$file" ]; then
    echo "Copying $file to home directory..."
    cp -f "$DOTFILES_DIR/$file" "$HOME/$file"
  fi
done

echo "Setup complete! Please restart your terminal or run 'source ~/.zshrc' or 'source ~/.bashrc' as needed." 