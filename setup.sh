#!/bin/bash

set -e

# 1. Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Install common packages
brew install git zsh vim tmux

# 3. Clone your dotfiles repo if not already present
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles from GitHub..."
  git clone https://github.com/mtuann/dotfiles.git "$DOTFILES_DIR"
fi

# 4. Copy dotfiles to home directory (overwrite if you want, or use symlinks)
for file in .bashrc .vimrc .zshrc .tmux.conf; do
  if [ -f "$DOTFILES_DIR/$file" ]; then
    echo "Copying $file to home directory..."
    cp -f "$DOTFILES_DIR/$file" "$HOME/$file"
  fi
done

echo "Setup complete! Please restart your terminal or run 'source ~/.zshrc' or 'source ~/.bashrc' as needed." 