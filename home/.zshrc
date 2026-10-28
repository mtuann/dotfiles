# ~/.zshrc - Zsh configuration with shared shell helpers.

# Load the shared shell helpers that are linked alongside this file in $HOME.
[ -f "$HOME/.shell_common.sh" ] && . "$HOME/.shell_common.sh"

# Keep a reasonably long interactive history and append instead of overwriting.
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt PROMPT_SUBST
autoload -Uz compinit && compinit

# Load conda's Zsh hook when conda is installed so "conda activate" works.
dotfiles_init_conda zsh

# Time each command for the prompt.
autoload -Uz add-zsh-hook
_dot_preexec() { _dot_start=$SECONDS; }
_dot_precmd() { _dot_took=$((SECONDS - ${_dot_start:-$SECONDS})); unset _dot_start; }
add-zsh-hook preexec _dot_preexec
add-zsh-hook precmd _dot_precmd

# Show conda env, user, working directory, git branch, and slow-command time in the prompt.
PROMPT='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }%B%F{green}%n%f:%F{blue}%~%f  %F{cyan}->  %F{yellow}$(git_branch)%f%F{magenta}$(cmd_time)%f%b %(#.#.$) '
