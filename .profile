# C locale causes encoding issues in Vim
export LANG=en_US.UTF-8

# Set default editor to Vim or similar
# E.g. used by tmux to determine keybindings
# E.g. used by bash for C-x C-e
if command -v vim >/dev/null
	then export VISUAL=vim
	else export VISUAL=vi
fi

# Use real symlinks on Windows
# Requires user to have SeCreateSymbolicLinkPrivilege
[ "$MSYSTEM" ] && MSYS=winsymlinks:nativestrict:$MSYS
