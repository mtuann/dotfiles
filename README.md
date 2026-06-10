# Dotfiles

What is in this repo:

- `home/`: stow package containing the dotfiles that get linked into `$HOME`
- `home/.bash_profile`: Bash login-shell bridge that loads `~/.bashrc`
- `home/.bashrc`: Bash-specific shell config
- `home/.zshrc`: Zsh-specific shell config
- `home/shell_common.sh`: shared aliases, helpers, and shell setup used by Bash and Zsh
- `home/.vimrc`: basic Vim config
- `home/.tmux.conf`: basic tmux config
- `home/.gitconfig`: basic Git config
- `setup.sh`: installs core tools, configures Conda/nvitop, and links dotfiles into `$HOME`
- `jupyter.sh`: creates or updates a small Conda devtools environment for local/Jupyter use
- `README.md`: quick usage notes

Setup:

```sh
git clone https://github.com/mtuann/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` installs core CLI tools with Homebrew or apt, installs `uv` when it
is missing, links the dotfiles into `$HOME`, installs Miniconda when no Conda
installation is found, enables automatic `base` activation, and installs
`nvitop` into the Conda `base` environment only when it is not already present.
Bash and Zsh both load the shared `home/shell_common.sh`, where `nvi` is
aliased to `nvitop`.

Without `sudo` on Debian/Ubuntu, skip only the apt package install step:

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

`setup.sh` links files from this repo's `home/` directory into `$HOME`.
If `stow` is available it uses `stow`; otherwise it falls back to plain symlinks.
Conflicting existing files are backed up with a timestamped `.bak.*` suffix.

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
