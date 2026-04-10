# ~/.zshrc - Zsh configuration with shared shell helpers.

# Load the shared shell helpers that are linked alongside this file in $HOME.
[ -f "$HOME/shell_common.sh" ] && . "$HOME/shell_common.sh"

# Keep a reasonably long interactive history and append instead of overwriting.
HISTSIZE=10000
SAVEHIST=2000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt PROMPT_SUBST

# Load conda's Zsh hook when conda is installed so "conda activate" works.
dotfiles_init_conda zsh

# Show conda env, user, working directory, and git branch in the prompt.
PROMPT='${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }%B%F{green}%n%f:%F{blue}%~%f  %F{cyan}->  %F{yellow}$(git_branch)%f%b %(#.#.$) '
