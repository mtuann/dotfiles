#!/usr/bin/env bash

set -euo pipefail

# Core setup options and the dotfiles package to link into $HOME.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_SHELL="$(basename "${SHELL:-}")"
ALLOW_SUDO=1
PACKAGE_STATUS=""
UV_STATUS=""
LINK_STATUS=""
DOTFILES_PACKAGE="home"
DOTFILES_PACKAGE_DIR="$SCRIPT_DIR/$DOTFILES_PACKAGE"
DOTFILES_FILES=(.bashrc .zshrc .vimrc .tmux.conf .gitconfig shell_common.sh)

# Pick the shell rc file to reference in post-install messages.
case "$CURRENT_SHELL" in
  bash)
    SHELL_RC="$HOME/.bashrc"
    ;;
  zsh)
    SHELL_RC="$HOME/.zshrc"
    ;;
  *)
    SHELL_RC=""
    ;;
esac

# Basic CLI help.
usage() {
  cat <<'EOF'
Usage: ./setup.sh [--no-sudo] [--help]

  --no-sudo  Skip apt package installation on Debian/Ubuntu.
  --help     Show this help message.
EOF
}

# Parse optional flags before running setup.
while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-sudo)
      ALLOW_SUDO=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

# Print the safest shell reload hint for the current shell.
print_reload_hint() {
  if [ -n "$SHELL_RC" ]; then
    echo "Please restart your terminal or run 'source $SHELL_RC' to activate the new config"
  else
    echo "Please restart your terminal and source your shell config manually"
  fi
}

# Make brew available in PATH after a fresh Homebrew install.
ensure_brew_in_path() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  command -v brew >/dev/null 2>&1
}

# Install system dependencies when the OS/package manager supports it.
install_packages() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    if ! command -v brew >/dev/null 2>&1; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if ! ensure_brew_in_path; then
      echo "Homebrew was installed but is not available in PATH yet."
      echo "Run the shellenv command from the Homebrew installer output, then rerun setup.sh."
      exit 1
    fi
    brew install git zsh vim tmux curl stow
    PACKAGE_STATUS="Installed Git, Zsh, Vim, Tmux, Curl, and Stow"
  elif [[ -f /etc/debian_version ]]; then
    echo "Detected Ubuntu/Debian"
    if [ "$ALLOW_SUDO" -eq 1 ]; then
      sudo apt update
      sudo apt install -y git zsh vim tmux curl stow
      PACKAGE_STATUS="Installed Git, Zsh, Vim, Tmux, Curl, and Stow"
    else
      echo "Skipping apt install because --no-sudo was provided."
      echo "Please install git, zsh, vim, tmux, curl, and optionally stow manually or via conda/nix."
      PACKAGE_STATUS="Package install skipped (--no-sudo)"
    fi
  else
    echo "Unsupported OS. Please install git, zsh, vim, tmux, curl, and optionally stow manually."
    echo "For UV installation, visit: https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
  fi
}

# Install uv only when it is not already available.
install_uv() {
  if command -v uv >/dev/null 2>&1; then
    echo "UV is already installed"
    UV_STATUS="UV already installed"
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install UV automatically. Skipping UV install."
    UV_STATUS="UV skipped (curl not found)"
    return 0
  fi

  echo "Installing UV..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  echo "UV installed successfully!"
  print_reload_hint
  UV_STATUS="Installed UV"
}

# Preserve existing files before replacing them with links.
backup_conflicting_targets() {
  local file
  local source
  local target
  local backup

  for file in "${DOTFILES_FILES[@]}"; do
    source="$DOTFILES_PACKAGE_DIR/$file"
    target="$HOME/$file"

    if [ -L "$target" ] && [ -e "$target" ] && [ "$target" -ef "$source" ]; then
      continue
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
      echo "Backing up $target to $backup..."
      mv "$target" "$backup"
    fi
  done
}

# Preserve an existing local ~/.gitconfig by migrating it into ~/.gitconfig.local
# before the shared dotfiles version is linked into place.
migrate_gitconfig_local_if_needed() {
  local current_gitconfig="$HOME/.gitconfig"
  local repo_gitconfig="$DOTFILES_PACKAGE_DIR/.gitconfig"
  local local_gitconfig="$HOME/.gitconfig.local"

  if [ -f "$local_gitconfig" ]; then
    return 0
  fi

  if [ ! -e "$current_gitconfig" ]; then
    return 0
  fi

  if [ -L "$current_gitconfig" ] && [ -e "$current_gitconfig" ] && [ "$current_gitconfig" -ef "$repo_gitconfig" ]; then
    return 0
  fi

  echo "Migrating existing ~/.gitconfig to ~/.gitconfig.local..."
  cp "$current_gitconfig" "$local_gitconfig"
}

# Link the dotfiles package with GNU stow when available.
link_with_stow() {
  echo "Linking dotfiles with stow..."
  stow --target="$HOME" --dir="$SCRIPT_DIR" --restow "$DOTFILES_PACKAGE"
  LINK_STATUS="Linked dotfiles with stow"
}

# Fall back to plain symlinks when stow is not installed.
link_with_symlinks() {
  local file
  local source
  local target

  echo "stow not found; linking dotfiles with symlinks..."
  for file in "${DOTFILES_FILES[@]}"; do
    source="$DOTFILES_PACKAGE_DIR/$file"
    target="$HOME/$file"
    ln -sfn "$source" "$target"
  done
  LINK_STATUS="Linked dotfiles with symlinks"
}

# Pick the linking strategy after checking the package directory exists.
link_dotfiles() {
  if [ ! -d "$DOTFILES_PACKAGE_DIR" ]; then
    echo "Expected dotfiles package directory at $DOTFILES_PACKAGE_DIR"
    exit 1
  fi

  migrate_gitconfig_local_if_needed
  backup_conflicting_targets

  if command -v stow >/dev/null 2>&1; then
    link_with_stow
  else
    link_with_symlinks
  fi
}

# Reload tmux immediately when setup is run inside an active tmux session.
reload_tmux_if_running() {
  if command -v tmux >/dev/null 2>&1 && [ -n "${TMUX:-}" ] && [ -f "$HOME/.tmux.conf" ]; then
    echo "Reloading tmux config..."
    tmux source-file "$HOME/.tmux.conf"
  fi
}

print_git_identity_hint() {
  if [ -f "$HOME/.gitconfig.local" ]; then
    return 0
  fi

  echo ""
  echo "Git identity is not configured yet."
  echo "Create $HOME/.gitconfig.local with:"
  cat <<'EOF'
cat > ~/.gitconfig.local <<'GITCONFIG'
[user]
    name = Your Name
    email = you@example.com
GITCONFIG
EOF
}

# Run the full setup flow.
install_packages
install_uv
link_dotfiles
reload_tmux_if_running
print_git_identity_hint

echo ""
echo "Setup complete."
echo ""
echo "What was configured:"
echo "  $PACKAGE_STATUS"
echo "  $UV_STATUS"
echo "  $LINK_STATUS"
echo "  Dotfiles source: $DOTFILES_PACKAGE_DIR"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
case "$CURRENT_SHELL" in
  bash)
    echo "  2. Or run: source ~/.bashrc"
    ;;
  zsh)
    echo "  2. Or run: source ~/.zshrc"
    ;;
  *)
    echo "  2. Or source your shell config manually"
    ;;
esac
echo "  3. Test UV: uv --version"
echo "  4. Create a new project: uv init myproject"
