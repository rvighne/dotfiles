# Set variables used as prompt segments by PS1
# Called often, so avoid external commands and minimize subshells
PROMPT_COMMAND=prompt_cmd
prompt_cmd() {
	local st=$?
	if [ $st -eq 0 ]
		then _lstst=
	elif [ $st -le 128 ] || ! _lstst="$(kill -l $st 2>/dev/null) "
		then _lstst="$st "
	fi

	_njobs=
	for _ in $(jobs -p); do : $((_njobs+=1)); done
	[ $_njobs ] && _njobs="[$_njobs] "

	history -a
}

# Clear gap between command output and shell prompt
PS1='\n'

# Set title to basename of current directory
case $TERM in xterm*) PS1=$PS1'\[\e];\W\a\]';; esac

# Error code or signal name in red
PS1=$PS1'\[\e[31m\]$_lstst'

# Number of background jobs in cyan
PS1=$PS1'\[\e[36m\]$_njobs'

# Current directory in green
PS1=$PS1'\[\e[32m\]\w'

# Git status in cyan (requires git-prompt.sh)
command -v __git_ps1 >/dev/null && PS1=$PS1'\[\e[36m\]$(__git_ps1)'

# Space before command with colors reset
PS1=$PS1'\[\e[0m\] '
