#!/usr/bin/env bash

set -euo pipefail

# Default environment mode and packages to install into the conda env.
CURRENT_SHELL="$(basename "${SHELL:-}")"
PACKAGES=(git zsh vim tmux curl)
ENV_MODE="name"
ENV_NAME="devtools"
ENV_PATH=""
ENV_PATH_DISPLAY=""

# Basic CLI help.
usage() {
  cat <<'EOF'
Usage: ./jupyter.sh [--local | --name NAME | --path PATH] [--help]

  --local      Use ~/envs/devtools.
  --name NAME  Use a named conda environment. Default: devtools
  --path PATH  Use a conda environment at a filesystem path.
  --help       Show this help message.
EOF
}

# Expand a ~/... path into an absolute filesystem path.
expand_path() {
  case "$1" in
    "~")
      printf '%s\n' "$HOME"
      ;;
    "~/"*)
      printf '%s/%s\n' "$HOME" "${1#~/}"
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

# Convert an absolute path under $HOME back into a shorter ~/... display form.
pretty_path() {
  case "$1" in
    "$HOME")
      printf '~\n'
      ;;
    "$HOME"/*)
      printf '~/%s\n' "${1#"$HOME"/}"
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

# Parse the requested environment mode before touching conda.
while [ "$#" -gt 0 ]; do
  case "$1" in
    --local)
      ENV_MODE="path"
      ENV_PATH="$HOME/envs/devtools"
      ENV_PATH_DISPLAY="~/envs/devtools"
      ;;
    --name)
      [ "$#" -ge 2 ] || { echo "--name requires a value" >&2; exit 1; }
      ENV_MODE="name"
      ENV_NAME="$2"
      shift
      ;;
    --path)
      [ "$#" -ge 2 ] || { echo "--path requires a value" >&2; exit 1; }
      ENV_MODE="path"
      ENV_PATH="$(expand_path "$2")"
      ENV_PATH_DISPLAY="$(pretty_path "$ENV_PATH")"
      shift
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

# Normalize the activation target and user-facing label.
if [ "$ENV_MODE" = "name" ]; then
  ACTIVATE_TARGET="$ENV_NAME"
  ENV_LABEL="$ENV_NAME"
else
  ACTIVATE_TARGET="$ENV_PATH"
  ENV_LABEL="$ENV_PATH_DISPLAY"
fi

# Print shell-specific commands to make future conda activation work.
print_conda_activation_help() {
  echo "To activate this environment later, run: conda activate $ENV_LABEL"
  echo "=== Shell setup for Conda ==="
  echo "If you use Bash: conda init bash && source ~/.bashrc"
  echo "If you use Zsh:  conda init zsh && source ~/.zshrc"
  if [ "$CURRENT_SHELL" = "bash" ]; then
    echo "Current shell hint: conda init bash && source ~/.bashrc && conda activate $ENV_LABEL"
  elif [ "$CURRENT_SHELL" = "zsh" ]; then
    echo "Current shell hint: conda init zsh && source ~/.zshrc && conda activate $ENV_LABEL"
  fi
}

# Locate conda and load the shell hook needed for "conda activate".
if command -v conda >/dev/null 2>&1; then
  CONDA_BASE="$(conda info --base)"
elif [ -x /opt/conda/bin/conda ]; then
  CONDA_BASE="/opt/conda"
elif [ -x "$HOME/miniconda3/bin/conda" ]; then
  CONDA_BASE="$("$HOME/miniconda3/bin/conda" info --base)"
else
  echo "Conda was not found. Please install or load conda first."
  exit 1
fi

source "$CONDA_BASE/etc/profile.d/conda.sh"

# Create the requested environment if it does not already exist.
ENV_CREATED=0

if [ "$ENV_MODE" = "name" ]; then
  echo "=== Creating conda environment: $ENV_NAME (if it doesn't exist) ==="
  if ! conda env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    conda create -n "$ENV_NAME" -c conda-forge "${PACKAGES[@]}" -y
    ENV_CREATED=1
  fi
else
  echo "=== Creating conda environment at: $ENV_PATH_DISPLAY (if it doesn't exist) ==="
  if [ ! -d "$ENV_PATH/conda-meta" ]; then
    mkdir -p "$(dirname "$ENV_PATH")"
    conda create -p "$ENV_PATH" -c conda-forge "${PACKAGES[@]}" -y
    ENV_CREATED=1
  else
    echo "Conda environment already exists at $ENV_PATH_DISPLAY"
  fi
fi

# Activate the env and update packages when reusing an existing environment.
echo "=== Activating conda environment ==="
conda activate "$ACTIVATE_TARGET"

if [ "$ENV_CREATED" -eq 0 ]; then
  echo "=== Installing packages (git, zsh, vim, tmux, curl) from conda-forge ==="
  conda install -c conda-forge "${PACKAGES[@]}" -y
fi

# Print the final activation hints for interactive use.
echo "=== Done ==="
echo "You are now inside the conda environment: $ENV_LABEL"
echo "=== Working on JupyterHub ==="
print_conda_activation_help
echo "To make shell setup consistent, run: ./setup.sh --no-sudo"
