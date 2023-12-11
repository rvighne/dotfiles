# Only source if interactive shell
case $- in
	*i*) ;;
	*) return
esac

# Reconfigure tty (if present) to allow any key to resume after C-s
stty ixany 2>/dev/null

# (Re)attach tmux session if connecting remotely and it's installed
# Using tmux -V (not command -v tmux), in case tmux exists but is broken
if [ "${SSH_TTY:+x}${TMUX+y}" = x ] && tmux -V
	then exec tmux new -As main
fi

# Colors, type indicators, and human-readable sizes in ls
alias ls='ls --color=auto -hF'
alias la='ls -A'
alias ll='ls -la'

# Show brief directory listing on directory change
command -v timeout >/dev/null && cd() {
	command cd "$@" || return
	timeout .025s ls --color=auto -hF || true
}

# Colors and human-readable sizes for iproute2
alias ip='ip -color=auto -h'

# Human-readable sizes in various tools
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Show full cmdline and PID in pstree
alias pstree='pstree -ap'

# Use same diff and grep implementations in or out of Git repo
alias diff='git diff --no-index --no-textconv --no-ext-diff'
alias grep='git grep --no-index --no-recursive'

# Use BFS (faster, interactive-friendly superset of find) if available
command -v bfs >/dev/null && alias find='bfs'

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && command cd -- "$1"; }

# Show all my own processes (useful over SSH)
pt() { pstree "$@" -- "$USER"; }

# Search all my own processes
alias pg='pgrep -au "$USER"'

# cut -f, but treat any run of whitespace as a delimiter
get() { tr -s '[:blank:]' '\t' | cut -f "$1"; }

# Package maintenance on Ubuntu
alias up='sudo apt update && sudo apt full-upgrade --auto-remove --purge -y'

# Start ssh-agent with a known path so we don't need a .env file
alias start_agent='ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null'

# Git, but use difftastic instead of internal diff whenever possible
mgit() { git -c diff.external=difft "$@" --ext-diff; }

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='git --git-dir ~/.cfg.git --work-tree ~'
alias cfg-edit='GIT_DIR=~/.cfg.git "$VISUAL"'

# Fetch Vim plugins and rebuild helptags
cfg_plug() {
	cfg submodule update --init --recursive --remote --depth 1 || return
	command vim -es +'helptags ALL' +q || true
}

# Integrate fzf with bash (e.g. for history search) if installed
command -v fzf >/dev/null && . ~/.vim/pack/plugins/start/fzf/shell/key-bindings.bash

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

# Empty line and ring bell (used by tmux) after each command
PS1='\a\n'

# Set title to basename of current directory
case $TERM in xterm*) PS1=$PS1'\[\e];\W\a\]';; esac

# Timestamp of the last command completion in dim text
PS1=$PS1'\[\e[2m\]\t\[\e[22m\] '

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

# Machine-local or private shell config
[ -O ~/.config/bash/bashrc ] && . ~/.config/bash/bashrc

if [ ${BASH_VERSION+x} ]
then
	# At end of .bashrc to avoid conflicting with prior shell init code
	shopt -s autocd checkhash
	shopt -s globstar extglob
	shopt -s no_empty_cmd_completion histreedit
	shopt -s checkjobs
	shopt -s histappend

	# Bash doesn't recognize - as an argument for autocd
	alias -- -='cd -'

	HISTTIMEFORMAT='%F %T  '
	HISTCONTROL=ignoreboth:erasedups

	# Make HISTFILESIZE use the default ($HISTSIZE, which we set to unlimited)
	HISTSIZE=
	unset HISTFILESIZE

	# Must come after any shell init code where HISTFILESIZE is set
	HISTFILE=~/.bash_history_eternal
fi
