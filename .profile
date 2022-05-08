# C locale causes encoding issues in Vim
export LANG=en_US.UTF-8

# Built from source or local programs
export PATH=~/.local/bin:$PATH

# Set default editor to Vim or similar
# E.g. used by tmux to determine keybindings
# E.g. used by bash for C-x C-e
export VISUAL=$(command -v vim || command -v vi)

# Interactive-friendly settings for less
export LESS=-iRx4

# Use real symlinks on Windows
# Requires user to have SeCreateSymbolicLinkPrivilege
[ ${MSYSTEM+x} ] && export MSYS=winsymlinks:nativestrict:$MSYS

# Use fancy colors for ls if GNU dircolors is available
command -v dircolors >/dev/null && eval "$(exec dircolors -b)"

# Use input filter for less if lesspipe is available
command -v lesspipe >/dev/null && eval "$(SHELL=/bin/sh exec lesspipe)"

# Use Vim plugin-local fzf globally if installed
fzf=~/.vim/pack/plugins/start/fzf/bin
[ -x "$fzf"/fzf ] && PATH=$fzf:$PATH
unset fzf

# Ensure that SSH agent is started and accessible
env=~/.ssh/agent.env
no_agent() {
	ssh-add -l >/dev/null 2>&1
	[ $? -eq 2 ]
}

if no_agent
then
	[ -e "$env" ] && . "$env" >/dev/null
	no_agent && (umask 066; exec ssh-agent -s >|"$env") && . "$env" >/dev/null
fi

unset env no_agent
