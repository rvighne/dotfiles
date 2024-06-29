# Speed up locale-aware tools (e.g. sort) since C locale is English anyway.
# Specify encoding so that some programs (e.g. Vim) are Unicode aware.
# It's the only "locale" supported by musl anyway, and is the same as POSIX.
export LANG=C.UTF-8

# Personal scripts and built from source programs
export PATH=~/bin:~/.local/bin:$PATH

# Set default editor to Vim or similar
# E.g. used by tmux to determine keybindings
# E.g. used by bash for C-x C-e
export VISUAL=$(command -v vim || command -v vi)
export EDITOR=$VISUAL # compatibility with tools that only read EDITOR

# Interactive-friendly settings for less
export LESS=-iRx4

# Use Vim to show manpages (with hyperlinks and colors)
command -v vim >/dev/null && export MANPAGER='vim +MANPAGER --not-a-term -'

# Use ripgrep to speed up FZF and ease searching Git repos
command -v rg >/dev/null && export FZF_DEFAULT_COMMAND='rg --files'

# Use real symlinks on Windows
# Requires user to have SeCreateSymbolicLinkPrivilege
[ ${MSYSTEM+x} ] && export MSYS=winsymlinks:nativestrict:$MSYS

# Use fancy colors for ls if GNU dircolors is available
command -v dircolors >/dev/null && eval "$(dircolors -b)"

# Use input filter for less if lesspipe is available
command -v lesspipe >/dev/null && eval "$(lesspipe)"

# Configure difftastic (AST-level diff tool)
export DFT_PARSE_ERROR_LIMIT=32767
export DFT_DISPLAY=side-by-side-show-both DFT_TAB_WIDTH=4
export DFT_BACKGROUND=light DFT_SYNTAX_HIGHLIGHT=off

# Disable -M (monitoring port) in favor of ServerAliveInterval
export AUTOSSH_PORT=0

# Connect to ssh-agent at a known path if no agent was forwarded
if
	ssh-add -l >/dev/null 2>&1
	[ $? -eq 2 ]
then
	export SSH_AUTH_SOCK=/dev/shm/$USER.ssh-agent.sock
fi

# Machine-local or private env vars
[ -O ~/.env ] && . ~/.env
