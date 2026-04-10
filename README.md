# Dotfiles

What is in this repo:

- `home/`: stow package containing the dotfiles that get linked into `$HOME`
- `home/.bashrc`: Bash-specific shell config
- `home/.zshrc`: Zsh-specific shell config
- `home/shell_common.sh`: shared aliases, helpers, and shell setup used by Bash and Zsh
- `home/.vimrc`: basic Vim config
- `home/.tmux.conf`: basic tmux config
- `home/.gitconfig`: basic Git config
- `setup.sh`: installs required packages and links dotfiles into `$HOME`
- `jupyter.sh`: creates or updates a Conda environment for local/Jupyter use
- `README.md`: quick usage notes

Setup:

```sh
git clone https://github.com/mtuann/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

Without `sudo` on Debian/Ubuntu:

```sh
./setup.sh --no-sudo
```

Conda env:

```sh
./jupyter.sh
./jupyter.sh --local
```

Custom env:

```sh
./jupyter.sh --name myenv
./jupyter.sh --path ~/envs/myenv
```

`setup.sh` links files from `~/dotfiles/home` into `$HOME`.
If `stow` is available it uses `stow`; otherwise it falls back to plain symlinks.

If you want Git identity in this setup, create `~/.gitconfig.local`:

```sh
cat > ~/.gitconfig.local <<'GITCONFIG'
[user]
    name = Your Name
    email = you@example.com
GITCONFIG
```

This file is optional, stays outside the repo, and is not managed by the dotfiles symlink setup.
If you already have `~/.gitconfig`, `setup.sh` will copy it to `~/.gitconfig.local` on first setup.
