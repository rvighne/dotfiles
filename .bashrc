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
alias cfg-plug='cfg submodule update --init --recursive --remote --depth 1'

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && cd -- "$1"; }

# Make TUI programs work on Windows
if command -v winpty >/dev/null
then
	alias stack='winpty stack'
	alias latexmk='winpty latexmk'
fi

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

# Git completions and prompt helper on FreeBSD
GIT_CONTRIB=/usr/local/share/git-core/contrib
if [ -d $GIT_CONTRIB ]
then
	. $GIT_CONTRIB/completion/git-completion.bash
	. $GIT_CONTRIB/completion/git-prompt.sh
fi

# Blank line for separation
PS1="\n"
# Set title to basename of current directory
PS1="$PS1\[\e];\W\a\]"
# Error code or signal name in red
PS1="$PS1\[\e[31m\]\$(cmd_status)"
# Current directory in green
PS1="$PS1\[\e[32m\]\w"
# Git status (git-prompt.sh must be sourced) in cyan
PS1="$PS1\[\e[36m\]\$(__git_ps1)"
# Space before command in default style
PS1="$PS1\[\e[0m\] "

# Helper function for prompt
cmd_status() {
	local st=$? sig
	if [ $st -gt 128 ] && sig=$(kill -l $st 2>/dev/null)
	then
		printf '%s ' "$sig"
	elif [ $st -ne 0 ]
		then printf '%d ' $st
	fi
}
