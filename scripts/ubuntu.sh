#!/usr/bin/env bash
# Ubuntu/Debian: core CLI tools, uv, Miniforge (conda), and nvitop on GPU machines.
# --no-sudo: skip apt and install the tools into conda base instead (clusters, JupyterHub).
set -euo pipefail
PKGS=(git zsh vim tmux curl)
NO_SUDO=0; if [ "${1:-}" = "--no-sudo" ]; then NO_SUDO=1; fi
export PATH="$HOME/.local/bin:$PATH"

if [ "$NO_SUDO" -eq 0 ]; then
  sudo apt-get update && sudo apt-get install -y "${PKGS[@]}"
fi

command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh

# Reuse any existing conda; otherwise install Miniforge (conda-forge only, no Anaconda ToS).
# On JupyterHub only $HOME survives a restart, so conda outside $HOME is not reused there.
CONDA=""
for c in ~/miniforge3/bin/conda "${CONDA_EXE:-}" "$(command -v conda || true)" ~/miniconda3/bin/conda /opt/conda/bin/conda; do
  if [ -x "$c" ]; then CONDA="$c"; break; fi
done
if [ -z "$CONDA" ] || { [ -n "${JUPYTERHUB_USER:-}" ] && [[ "$CONDA" != "$HOME"/* ]]; }; then
  curl -fsSL "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh" -o /tmp/miniforge.sh
  bash /tmp/miniforge.sh -b -p ~/miniforge3 && rm -f /tmp/miniforge.sh
  CONDA=~/miniforge3/bin/conda
fi
"$CONDA" config --set changeps1 false   # our prompt already shows the env

if [ "$NO_SUDO" -eq 1 ]; then
  "$CONDA" install -n base -y --override-channels -c conda-forge "${PKGS[@]}"
fi
"$CONDA" clean -a -y >/dev/null   # drop cached downloads (~100 MB)

if command -v nvidia-smi >/dev/null && ! command -v nvitop >/dev/null; then
  uv tool install nvitop
fi
