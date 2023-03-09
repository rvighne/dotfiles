# C locale causes encoding issues in Vim
export LANG=en_US.UTF-8

# Personal scripts and built from source programs
export PATH=~/bin:~/.local/bin:$PATH

# Set default editor to Vim or similar
# E.g. used by tmux to determine keybindings
# E.g. used by bash for C-x C-e
export VISUAL=$(command -v vim || command -v vi)

# Interactive-friendly settings for less
export LESS=-iRx4

# Use Vim to show manpages (with hyperlinks and colors)
# manpager.vim has a bug where it forgets to reset 'modifiable'
export MANPAGER='vim +MANPAGER +setlocal\ nomodifiable --not-a-term -'

# Use ripgrep to speed up FZF and ease searching Git repos
command -v rg >/dev/null && export FZF_DEFAULT_COMMAND='rg --files'

# Use real symlinks on Windows
# Requires user to have SeCreateSymbolicLinkPrivilege
[ ${MSYSTEM+x} ] && export MSYS=winsymlinks:nativestrict:$MSYS

# Use fancy colors for ls if GNU dircolors is available
command -v dircolors >/dev/null && eval "$(dircolors -b)"

# Use input filter for less if lesspipe is available
command -v lesspipe >/dev/null && eval "$(lesspipe)"

# Use Vim plugin-local fzf globally if installed
fzf=~/.vim/pack/plugins/start/fzf/bin
[ -x "$fzf"/fzf ] && PATH=$fzf:$PATH
unset fzf

if
	ssh-add -l >/dev/null 2>&1
	[ $? -eq 2 ]
then
	export SSH_AUTH_SOCK=/dev/shm/$USER.ssh-agent.sock
fi

# Machine-local or private env vars
. ~/.env
