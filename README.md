# Dotfiles Setup and Explanation

This folder contains configuration files (dotfiles) for customizing your Unix-like shell environment, editor, and terminal multiplexer. Each file is explained below so you can understand and further customize your setup.

---

## 🐚 .bashrc

- **Shell configuration for bash**
- **Key sections:**
  - **Conda environment in prompt:** Shows the active conda environment (e.g., `(base)`).
  - **Colored prompt:** Username (green), working directory (blue), arrow (cyan), git branch (yellow).
  - **Aliases:** Shortcuts for common `ls` and `git` commands.
  - **Git branch in prompt:** Shows current git branch if in a git repo.
  - **History settings:** Controls how many commands are remembered and how duplicates are handled.
  - **Bash completion:** Enables tab completion for many commands.
  - **Default editor:** Sets `vim` as the default editor.

---

## 🐚 .zshrc

- **Shell configuration for zsh**
- **Key sections:**
  - **Homebrew initialization:** Adds Homebrew to your PATH if installed.
  - **Aliases:** Shortcuts for `ls` and `tmux`.
  - **Prompt:** Username (green), git branch (cyan), working directory (blue), arrow (cyan).
  - **Git branch in prompt:** Uses `vcs_info` to show the current git branch.
  - **Conda initialization:** Activates conda environments and shows them in the prompt.

---

## 📝 .vimrc

- **Vim editor configuration**
- **Key sections:**
  - **Syntax highlighting:** Enables color and syntax for code.
  - **Colorscheme:** Uses the built-in `desert` theme for readability.
  - **Indentation:** 4 spaces per tab, spaces instead of tabs.
  - **Line numbers and ruler:** Shows line numbers and cursor position.
  - **Search enhancements:** Highlights search results, incremental search, smart case.
  - **Status line:** Shows file info, type, position, and length.
  - **(Optional) Mouse and clipboard:** Can enable mouse and system clipboard support.

---

## 🖥️ .tmux.conf

- **tmux terminal multiplexer configuration**
- **Key sections:**
  - **Prefix key:** Set to `` ` `` instead of default `Ctrl-b`.
  - **Mouse support:** Allows mouse for pane selection and resizing.
  - **256-color support:** Ensures color schemes display correctly.
  - **Status bar:** Shows at the bottom, with date and time, and custom colors.
  - **Vi mode:** Enables vi-style keybindings in copy mode.
  - **Pane/window management:** Easy splitting and navigation.

---

## 📥 Copy Your Dotfiles Here

To back up your current configuration files to this folder, run:

```bash
mkdir -p ~/Desktop/work/dotfiles
cp ~/.bashrc ~/.vimrc ~/.zshrc ~/.tmux.conf ~/Desktop/work/dotfiles/
```

This will copy your existing dotfiles into the `dotfiles` folder for version control or sharing.

---

## How to Use

1. Copy these files to your home directory (or symlink them for version control).
2. Reload your shell or source the relevant file (e.g., `source ~/.bashrc`).
3. Open a new terminal or Vim/tmux session to see the changes.

Feel free to further customize these files to match your workflow!


