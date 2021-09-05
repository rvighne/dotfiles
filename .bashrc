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
	shopt -s direxpand
	shopt -s globstar failglob
	shopt -s checkjobs
	shopt -s histappend
	shopt -s no_empty_cmd_completion
	HISTCONTROL=ignoreboth:erasedups
	HISTSIZE=10000
esac

# Type indicators and human-readable sizes in ls
LS_CMD='ls -hF'

# Terminal colors on both GNU and BSD
if ls --help 2>/dev/null | grep -q -- --color
	then LS_CMD="$LS_CMD --color=auto"
	else LS_CMD="$LS_CMD -G"
fi

# Hide registry hive files on Windows
[ -f ~/NTUSER.DAT ] && LS_CMD="$LS_CMD -I NTUSER.DAT\\*"

# Common ls shortcuts
alias ls=$LS_CMD
alias la='ls -A'
alias ll='ls -la'
unset LS_CMD

# Show brief directory listing on directory change
cd() { command cd "$@" && ls; }

# Bash doesn't recognize - as an argument for autocd
alias -- -='cd -'

# Colors for grep; works on both GNU and BSD
alias grep='grep --color'

# Colors for diff (GNU only)
# Use the same format as git-diff
if diff --help 2>/dev/null | grep -q -- --color
	then alias diff='diff -u --color'
	else alias diff='diff -u'
fi

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && command cd -- "$1"; }

# Show all my own processes (useful over SSH)
alias pt="pstree -aC age $LOGNAME"

# Start Jupyter Lab without activating Anaconda
alias jp='~/.local/opt/anaconda3/bin/jupyter-lab --no-browser'

# Generate secure random passwords
alias pw='tr -dc \[:graph:] </dev/urandom | fold -w12 | head -n'

# Find and count unique instances of a pattern
enum() { grep -oh "$@" | sort | uniq -c; }

# Check status of all Git repos
gst() { find "$1" -type d -name .git -exec git --git-dir {} --work-tree {}/.. status \;; }

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='command git --git-dir ~/.cfg.git --work-tree ~'
alias cfg-plug='cfg submodule update --init --recursive --remote --depth 1'

# Install configs for Windows Terminal (from WSL)
cfg-wt() {
	local wdst=$(wslvar LOCALAPPDATA)'\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\'
	local ldst=$(wslpath -- "$wdst")
	cp -- ~/.config/wt/settings.json "$ldst"
}

# Make TUI programs work on Windows
if command -v winpty >/dev/null
then
	alias pp='pipenv run winpty python'
	alias python='winpty python'
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

# Enable Node Version Manager if installed
[ -d ~/.nvm ] && . ~/.nvm/nvm.sh && . ~/.nvm/bash_completion

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
		then printf '%s ' "$sig"
	elif [ $st -ne 0 ]
		then printf '%d ' $st
	fi
}
