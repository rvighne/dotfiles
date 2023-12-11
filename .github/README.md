# Dotfiles

My \*nix configuration files. They are heavily commented, so please see the sources for details.

## Goals

I try to keep these dotfiles as portable as possible. They should work with minimal or zero machine-specific overrides on my work network (Debian with `$HOME` on NFS), work machine (macOS with Homebrew), home server (FreeBSD), and home PC (Windows 10).

## Usage

This should be used as a Git repo stored at `~/.cfg.git` with `$HOME` as the worktree. The `cfg` alias in `.bashrc` runs Git with this setup.

To install (note that the checkout will conflict with any existing dotfiles):

	git clone -n https://github.com/rvighne/dotfiles.git
	mv dotfiles/.git ~/.cfg.git
	rmdir dotfiles
	git --git-dir ~/.cfg.git --work-tree ~ checkout

Then, I highly recommended hiding untracked files (i.e. most of your home directory), setting `core.worktree` so that external tools work, and fetching the Vim plugins:

	cfg config status.showUntrackedFiles no
	cfg config diff.ignoreSubmodules all
	cfg config core.worktree ~
	cfg_plug

## Overrides

Some files (see `~/.gitignore`) are not meant to be checked in and serve as machine-local overrides for other dotfiles that are. Most optional components are auto-detected and enabled, but others must be configured here due to unmaintainable inter-distro differences. For example, to set up FZF, source the OS package's `key-bindings.bash` from `~/.config/bash/bashrc`, and symlink the Vim plugin to `~/.vim/pack/trial/fzf`. The same may be required for `git-prompt.sh` on some distros.
