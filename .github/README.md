# Dotfiles

My \*nix configuration files. They are heavily commented, so please see the sources for details.

## Goals

I try to make these dotfiles as portable as possible. My main machine is Windows with the MSYS2 Git distro (a fairly complete GNU environment). At the same time, most of my work is done remotely on GNU/Linux or FreeBSD machines, and I want these same configs to work there sans modification.

## Usage

This is intended to be used as a bare Git repo stored at `~/.cfg.git`, and using `$HOME` as the worktree. The `cfg` alias in `.bashrc` runs Git with this setup.

To install (note that the checkout will conflict with any existing dotfiles):

	git clone --bare https://github.com/rvighne/dotfiles.git ~/.cfg.git
	git --git-dir ~/.cfg.git --work-tree ~ checkout

Then, I highly recommended hiding untracked files (i.e. most of your home directory), and fetching the Vim plugins:

	cfg config status.showUntrackedFiles no
	cfg config diff.ignoreSubmodules all
	cfg submodule update --init --remote --recursive
