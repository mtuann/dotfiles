#!/usr/bin/env bash
# Install tools for this OS, then link home/* into $HOME.
# Usage: ./setup.sh [--no-sudo]   (--no-sudo: Linux only, skip apt)
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin) bash "$DIR/scripts/mac.sh" ;;
  Linux)  bash "$DIR/scripts/ubuntu.sh" "$@" ;;
  *)      echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

# Keep an existing personal ~/.gitconfig as ~/.gitconfig.local (included by ours).
if [ -f ~/.gitconfig ] && [ ! -L ~/.gitconfig ] && [ ! -f ~/.gitconfig.local ]; then
  cp ~/.gitconfig ~/.gitconfig.local
fi

# Symlink each dotfile; back up anything already in the way.
for src in "$DIR"/home/.[!.]*; do
  dst="$HOME/$(basename "$src")"
  if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then continue; fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"; fi
  ln -s "$src" "$dst"
  echo "linked $dst"
done

[ -f ~/.gitconfig.local ] || printf '\nSet your Git identity:\n  git config -f ~/.gitconfig.local user.name "Your Name"\n  git config -f ~/.gitconfig.local user.email you@example.com\n'
echo "Done. Restart your terminal."
