# Homebrew initialization (only if Homebrew is installed)
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# UV (Python package manager) initialization
if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

# Color support and aliases
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls='ls -GF'
alias ll="ls -alt"
alias la="ls -l"
alias tmux='tmux -u -2'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# UV aliases
alias uvvenv='uv venv'
alias uvrun='uv run'
alias uvsync='uv sync'
alias uvadd='uv add'
alias uva='source .venv/bin/activate'
alias uvd='deactivate'

# Tmux aliases
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'


# History settings (equivalent to Bash .bashrc)
HISTSIZE=10000
SAVEHIST=2000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY

# Prompt and git branch info
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)'
zstyle ':vcs_info:*' enable git
setopt PROMPT_SUBST
PROMPT="%B%F{green}%n\$vcs_info_msg_0_%f:%F{blue}%3~  %F{cyan}->  %b%f"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# (Optional) If you want to always have conda in PATH, uncomment below:
# export PATH="$HOME/miniconda3/bin:$PATH"


