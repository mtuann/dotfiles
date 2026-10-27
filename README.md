# Dotfiles

Shell, Git, tmux, and Vim config for macOS and Ubuntu.

```sh
git clone https://github.com/mtuann/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./setup.sh            # Linux without sudo: ./setup.sh --no-sudo
```

`setup.sh` runs the script for your OS, then symlinks everything in `home/` into `$HOME`.
Existing files are backed up as `<name>.bak.<timestamp>`. Safe to re-run.

## What gets installed

Tools that are already present are skipped.

| | macOS (`scripts/mac.sh`) | Ubuntu (`scripts/ubuntu.sh`) |
|---|---|---|
| Package manager | Homebrew, if missing | apt |
| CLI tools | `git gh tmux` | `git zsh vim tmux curl` |
| Python | `uv` | `uv` |
| Conda | none (use `uv`) | Miniforge (conda-forge only), unless conda already exists |
| GPU monitor | none | `nvitop`, if `nvidia-smi` exists |

With `--no-sudo`, apt is skipped and the CLI tools are installed into conda `base` instead
(useful on clusters and JupyterHub).

## JupyterHub

Run `./setup.sh --no-sudo` in a JupyterHub terminal. Only `$HOME` survives a server restart,
so when `JUPYTERHUB_USER` is set and the existing conda lives outside `$HOME` (e.g. `/opt/conda`),
Miniforge is installed to `~/miniforge3` and used instead. Other machines are unaffected.

Environments do not show up as notebook kernels automatically. Register each one:

```sh
python -m ipykernel install --user --name myenv            # inside an activated conda env
uv add --dev ipykernel && uv run python -m ipykernel install --user --name myproject
```

## Updating

```sh
cd ~/dotfiles && git pull
```

Files in `~` are symlinks into this repo, so changes apply in the next new shell.
Re-run `./setup.sh` only when a file is added to `home/` or a tool to `scripts/` (re-running is always safe).

## Layout

```
setup.sh            entry point: OS script + symlinks
scripts/mac.sh      macOS installs
scripts/ubuntu.sh   Ubuntu/Debian installs
home/               linked into $HOME
  .bashrc .zshrc    shell config (both load .shell_common.sh)
  .shell_common.sh  shared aliases, Homebrew/conda init, git prompt helper
  .bash_profile     login shells load .bashrc
  .gitconfig .tmux.conf .vimrc
```

To add a dotfile, put it in `home/` and re-run `./setup.sh`.
To add a tool, append it to the list in `scripts/mac.sh` or `PKGS` in `scripts/ubuntu.sh`.

## Git identity

Name and email live outside the repo in `~/.gitconfig.local` (included last by `home/.gitconfig`),
so they are set per machine and never committed:

```sh
git config -f ~/.gitconfig.local user.name "Your Name"
git config -f ~/.gitconfig.local user.email "ID+username@users.noreply.github.com"   # GitHub no-reply address
```

An existing `~/.gitconfig` is copied to `~/.gitconfig.local` on first run.

> Do not use `git config --global` after setup: `~/.gitconfig` is a symlink, so it writes into
> `home/.gitconfig` in this repo. Use `git config -f ~/.gitconfig.local` instead.
