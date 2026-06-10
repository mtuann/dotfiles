# Shared shell configuration for Bash and Zsh.

dotfiles_source_if_exists() {
  [ -f "$1" ] && . "$1"
}

dotfiles_init_homebrew() {
  local brew_bin resolved_brew

  resolved_brew="$(command -v brew 2>/dev/null || true)"
  for brew_bin in \
    "$resolved_brew" \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    "$HOME/.linuxbrew/bin/brew" \
    /home/linuxbrew/.linuxbrew/bin/brew
  do
    case "$brew_bin" in
      */brew)
        if [ -x "$brew_bin" ]; then
          eval "$("$brew_bin" shellenv)"
          return 0
        fi
        ;;
    esac
  done

  return 1
}

dotfiles_find_conda() {
  local conda_bin resolved_conda

  resolved_conda="$(command -v conda 2>/dev/null || true)"
  for conda_bin in \
    "${CONDA_EXE:-}" \
    "$HOME/miniconda3/bin/conda" \
    "$HOME/anaconda3/bin/conda" \
    /opt/conda/bin/conda \
    "$resolved_conda"
  do
    case "$conda_bin" in
      */conda)
        if [ -x "$conda_bin" ]; then
          printf '%s\n' "$conda_bin"
          return 0
        fi
        ;;
    esac
  done

  return 1
}

dotfiles_init_conda() {
  local shell_name="$1"
  local conda_bin conda_root __conda_setup

  conda_bin="$(dotfiles_find_conda)" || return 0
  conda_root="$(cd -- "$(dirname -- "$conda_bin")/.." && pwd)"
  __conda_setup="$("$conda_bin" "shell.$shell_name" "hook" 2>/dev/null || true)"

  if [ -n "$__conda_setup" ]; then
    eval "$__conda_setup"
  elif [ -f "$conda_root/etc/profile.d/conda.sh" ]; then
    . "$conda_root/etc/profile.d/conda.sh"
  else
    export PATH="$conda_root/bin:$PATH"
  fi
}

git_branch() {
  local branch

  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)" || \
    branch="$(git rev-parse --short HEAD 2>/dev/null)" || return 0

  [ -n "$branch" ] && printf ' (git:%s)' "$branch"
}

dotfiles_init_homebrew
dotfiles_source_if_exists "$HOME/.local/bin/env"

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export EDITOR=vim

case "$(uname -s)" in
  Darwin)
    alias ls='ls -G'
    ;;
  *)
    if ls --color=auto >/dev/null 2>&1; then
      alias ls='ls --color=auto'
    else
      alias ls='ls'
    fi
    ;;
esac

alias ll='ls -haltF'
alias lf='ls -halSF'
alias la='ls -A'
alias l='ls -CF'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

alias uvvenv='uv venv'
alias uvrun='uv run'
alias uvsync='uv sync'
alias uvadd='uv add'
alias uva='source .venv/bin/activate'
alias uvd='deactivate'

alias tmux='tmux -u -2'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'
alias nvi='nvitop'
