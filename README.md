# Dotfiles Setup and Explanation

This folder contains configuration files (dotfiles) for customizing your Unix-like shell environment, editor, and terminal multiplexer. Each file is explained below so you can understand and further customize your setup.

---

## 🚀 Quick Install (setup.sh)

Clone this repository and run the setup script to install dependencies and copy dotfiles to your home directory:

```sh
cd ~/Desktop/work/dotfiles
chmod +x ~/setup.sh
sh setup.sh
```

The script will:
- Install Homebrew (if not already installed)
- Install git, zsh, vim, and tmux
- Copy .bashrc, .vimrc, .zshrc, .tmux.conf, and .gitconfig to your home directory

After running the script, restart your terminal or run:

```sh
source ~/.zshrc   # for zsh
source ~/.bashrc  # for bash
```

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

> **Note:** After editing `.bashrc`, reload your shell or run `source ~/.bashrc` to activate changes.

---

## 🐚 .zshrc

- **Shell configuration for zsh**
- **Key sections:**
  - **Homebrew initialization:** Adds Homebrew to your PATH if installed.
  - **Aliases:** Shortcuts for `ls` and `tmux`.
  - **Prompt:** Username (green), git branch (cyan), working directory (blue), arrow (cyan).
  - **Git branch in prompt:** Uses `vcs_info` to show the current git branch.
  - **Conda initialization:** Activates conda environments and shows them in the prompt.

> **Note:** After editing `.zshrc`, reload your shell or run `source ~/.zshrc` to activate changes.

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

> **Note:** After editing `.vimrc`, restart Vim to see the changes.

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

> **Note:** After editing `.tmux.conf`, reload the config in tmux with `<prefix> + r` or restart tmux.

---

## 📥 Copy Your Dotfiles Here

To back up your current configuration files to this folder, run:

```bash
mkdir -p ~/Desktop/work/dotfiles
cp ~/.bashrc ~/.vimrc ~/.zshrc ~/.tmux.conf ~/Desktop/work/dotfiles/
```

This will copy your existing dotfiles into the `dotfiles` folder for version control or sharing.

---

## ⚡ Activating Changes

To apply changes after editing your dotfiles, use the following commands or actions:

```sh
# For .bashrc
source ~/.bashrc   # or restart your terminal

# For .zshrc
source ~/.zshrc    # or restart your terminal

# For .vimrc
# Restart Vim to see the changes

# For .tmux.conf
# Inside tmux, press <prefix> + r to reload, or restart tmux
tmux source-file ~/.tmux.conf
```

> **Tip:** Always reload or restart the relevant application or shell after editing its config file to ensure your changes take effect.

---

## How to Use

1. Copy these files to your home directory (or symlink them for version control).
2. Reload your shell or source the relevant file (e.g., `source ~/.bashrc`).
3. Open a new terminal or Vim/tmux session to see the changes.

Feel free to further customize these files to match your workflow!

