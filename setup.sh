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
  
  # Install UV (Python package manager)
  if ! command -v uv >/dev/null 2>&1; then
    echo "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "UV installed successfully!"
    echo "Please restart your terminal or run 'source ~/.zshrc' to activate UV"
  else
    echo "UV is already installed"
  fi
  
elif [[ -f /etc/debian_version ]]; then
  # Ubuntu/Debian
  echo "Detected Ubuntu/Debian"
  sudo apt update
  sudo apt install -y git zsh vim tmux curl
  
  # Install UV (Python package manager)
  if ! command -v uv >/dev/null 2>&1; then
    echo "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "UV installed successfully!"
    echo "Please restart your terminal or run 'source ~/.bashrc' to activate UV"
  else
    echo "UV is already installed"
  fi
  
else
  echo "Unsupported OS. Please install git, zsh, vim, and tmux manually."
  echo "For UV installation, visit: https://docs.astral.sh/uv/getting-started/installation/"
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

echo ""
echo "Setup complete! 🎉"
echo ""
echo "What was installed:"
echo "  ✅ Git, Zsh, Vim, Tmux"
echo "  ✅ UV (Python package manager)"
echo "  ✅ Dotfiles configuration"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Or run: source ~/.zshrc (for zsh) or source ~/.bashrc (for bash) or tmux source-file ~/.tmux.conf or source ~/.vimrc"
echo "  3. Test UV: uv --version"
echo "  4. Create a new project: uv init myproject" 