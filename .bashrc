# Only source if interactive shell
case $- in
	*i*) ;;
	*) return
esac

# (Re)attach tmux session if connecting remotely and it's installed
# Using tmux -V (not command -v tmux), in case tmux exists but is broken
[ "$SSH_TTY" -a -z "$TMUX" ] && tmux -V && exec tmux new -As main

# Interactive-friendly settings; see also .inputrc
case $0 in *bash)
	shopt -s autocd
	shopt -s extglob globstar
	shopt -s histappend
	shopt -s no_empty_cmd_completion
	shopt -s completion_strip_exe 2>/dev/null
	HISTCONTROL=ignoreboth:erasedups
esac

# Type indicators and human-readable sizes in ls
LS_CMD='ls -hF'

# Terminal colors on both GNU and BSD
if ls --help 2>/dev/null | grep -qF -- --color
	then LS_CMD="$LS_CMD --color=auto"
	else LS_CMD="$LS_CMD -G"
fi

# Hide registry hive files on Windows
[ -f ~/NTUSER.DAT ] && LS_CMD="$LS_CMD -I NTUSER.DAT\\*"

# Common ls shortcuts
alias ls="$LS_CMD"
alias la='ls -A'
alias ll='ls -la'
unset LS_CMD

# Show brief directory listing on directory change
cd() { command cd "$@" && ls; }

# Colors for grep; works on both GNU and BSD
alias grep='grep --color'

# Avoid vi-compatible mode
alias view='vim -M'

# Useful on remote systems
alias pt='pstree $(id -un)'

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='command git --git-dir ~/.cfg.git --work-tree ~'

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && cd -- "$1"; }

# Docker Compose is too verbose
if command -v docker-compose >/dev/null
then
	alias up='docker-compose up -d --build --remove-orphans'
	alias re='up --force-recreate --no-deps'
	alias down='docker-compose down'
	alias dps='docker-compose ps -a'
	alias logs='docker-compose logs -f'
	enter() { docker-compose exec "$1" bash; }
fi

# Colored prompt with
#   - preceding newline
#   - error code or signal name
#   - current directory
#   - git status (git-prompt.sh must be sourced)
PS1="\n\[$(tput setaf 1)\]\$(cmd_status)\[$(tput setaf 2)\]\w\[$(tput setaf 6)\]\$(__git_ps1)\[$(tput sgr0)\] "

# Set terminal title to basename of working directory
# Not using tput because tsl/fsl is often missing from terminfo
case $TERM in
	xterm*) PS1="\[\e];\W\a\]$PS1"
esac

# Helper function for PS1
cmd_status() {
	local st=$?
	if [ $st -gt 128 ]
		then printf '%s ' $(kill -l $st)
	elif [ $st -ne 0 ]
		then printf '%d ' $st
	fi
}
