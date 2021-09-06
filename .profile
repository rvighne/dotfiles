# C locale causes encoding issues in Vim
export LANG=en_US.UTF-8

# Set default editor to Vim or similar
# E.g. used by tmux to determine keybindings
# E.g. used by bash for C-x C-e
if command -v vim >/dev/null
	then export VISUAL=vim
	else export VISUAL=vi
fi

# Use fancy colors for ls if GNU dircolors is available
command -v dircolors >/dev/null && eval "$(exec dircolors -b)"

# Use input filter for less if lesspipe is available
command -v lesspipe >/dev/null && eval "$(SHELL=/bin/sh exec lesspipe)"

# Interactive-friendly settings for less
export LESS=-FRWx4

# Use real symlinks on Windows
# Requires user to have SeCreateSymbolicLinkPrivilege
[ "$MSYSTEM" ] && MSYS=winsymlinks:nativestrict:$MSYS

# Ensure that SSH agent is started and accessible
env=~/.ssh/agent.env
no_agent() {
	ssh-add -l >/dev/null 2>&1
	[ $? == 2 ]
}

if no_agent; then
	[ -r "$env" ] && . "$env" >/dev/null
	no_agent && (umask 066; exec ssh-agent -s >"$env") && . "$env" >/dev/null
fi

unset env no_agent
