# ~/.bashrc - Base configuration for bash

# Enable color support for ls and add handy aliases
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Function to show current git branch in prompt
git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    echo " (git:$branch)"
  fi
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
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

# Set a prompt that includes conda env, git branch, and colors
PS1="${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w  \[\e[0m\]\[\e[1;36m\]->  \[\e[0m\]\[\e[1;33m\]\$(git_branch)\[\e[0m\]\$ "

# History settings
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Enable bash completion if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Set default editor
export EDITOR=vim

# Source user profile if it exists
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi 