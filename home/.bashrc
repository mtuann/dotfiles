# ~/.bashrc - Bash configuration with shared shell helpers.

# Load the shared shell helpers that are linked alongside this file in $HOME.
[ -f "$HOME/shell_common.sh" ] && . "$HOME/shell_common.sh"

# Keep a reasonably long interactive history and append instead of overwriting.
HISTSIZE=10000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Load conda's Bash hook when conda is installed so "conda activate" works.
dotfiles_init_conda bash

# Show conda env, user, working directory, and git branch in the prompt.
PS1="${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w  \[\e[0m\]\[\e[1;36m\]->  \[\e[0m\]\[\e[1;33m\]\$(git_branch)\[\e[0m\]\$ "

# Enable system bash completion when it is available.
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
