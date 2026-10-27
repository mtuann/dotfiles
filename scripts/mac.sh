#!/usr/bin/env bash
# macOS: Homebrew + core CLI tools. Python is handled by uv (no conda on Mac).
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
brew_env() { eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"; }

command -v brew >/dev/null || brew_env
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_env
fi

# Install only what is missing (keeps tools you already have, e.g. Apple git).
for p in git gh tmux uv; do command -v "$p" >/dev/null || brew install "$p"; done
