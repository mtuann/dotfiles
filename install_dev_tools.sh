#!/bin/bash

set -e

# Cấu hình thư mục cài đặt
INSTALL_DIR="$HOME/.local"
mkdir -p "$INSTALL_DIR/bin"
mkdir -p "$HOME/src"
cd "$HOME/src"

NUM_CORES=$(nproc)

# 1. Install Git
echo "Installing Git..."
GIT_VERSION="2.42.0"
wget https://github.com/git/git/archive/refs/tags/v$GIT_VERSION.tar.gz -O git.tar.gz
tar -xzf git.tar.gz
cd git-$GIT_VERSION
make prefix=$INSTALL_DIR all -j$NUM_CORES
make prefix=$INSTALL_DIR install
cd ..

# 2. Install Zsh
echo "Installing Zsh..."
ZSH_VERSION="5.9"
wget https://sourceforge.net/projects/zsh/files/zsh/$ZSH_VERSION/zsh-$ZSH_VERSION.tar.xz
tar -xf zsh-$ZSH_VERSION.tar.xz
cd zsh-$ZSH_VERSION
./configure --prefix=$INSTALL_DIR
make -j$NUM_CORES
make install
cd ..

# 3. Install Vim
echo "Installing Vim..."
VIM_VERSION="9.1.0172"
git clone https://github.com/vim/vim.git
cd vim
git checkout v$VIM_VERSION
./configure --prefix=$INSTALL_DIR --with-features=huge --enable-multibyte --enable-python3interp
make -j$NUM_CORES
make install
cd ..

# 4. Install Tmux
echo "Installing Tmux..."
TMUX_VERSION="3.3a"
wget https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz
tar -xzf tmux-$TMUX_VERSION.tar.gz
cd tmux-$TMUX_VERSION
./configure --prefix=$INSTALL_DIR
make -j$NUM_CORES
make install
cd ..

# 5. Install curl
echo "Installing curl..."
CURL_VERSION="8.5.0"
wget https://curl.se/download/curl-$CURL_VERSION.tar.gz
tar -xzf curl-$CURL_VERSION.tar.gz
cd curl-$CURL_VERSION
./configure --prefix=$INSTALL_DIR
make -j$NUM_CORES
make install
cd ..

# 6. Add to PATH if not already
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    echo "[INFO] Added ~/.local/bin to PATH in .bashrc and .zshrc"
fi

echo ""
echo "✅ DONE! Tools installed to $INSTALL_DIR/bin"
echo "👉 Please restart your shell or run: source ~/.bashrc"

