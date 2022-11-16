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

# Type indicators and human-readable sizes in ls
ls='ls -hF'

# Terminal colors on both GNU and BSD
if ls --help 2>/dev/null | grep -q -- --color
	then ls="$ls --color=auto"
	else ls="$ls -G"
fi

# Hide registry hive files on Windows
[ -f ~/NTUSER.DAT ] && ls="$ls -I NTUSER.DAT\\*"

# Common ls shortcuts
alias ls="$ls"
alias la='ls -A'
alias ll='ls -la'
unset ls

# Show brief directory listing on directory change
# Avoid stat syscalls over NFS so (a) it stays responsive, and (b) I can tell I'm on NFS
cd() {
	command cd "$@" || return
	case $(stat -fc %T .) in
		nfs) command ls;;
		*) ls;;
	esac
}

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

# Human-readable sizes in various tools
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Show cmdline and color by start time
alias pstree='pstree -apC age'

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && command cd -- "$1"; }

# Make bc useful as interactive calculator
alias bc='bc -ql'

# Show all my own processes (useful over SSH)
pt() { pstree "$@" -- "$USER"; }

# Generate secure random passwords
alias pw='tr -dc \[:graph:] </dev/urandom | fold -b -w12'

# Find and count unique instances of a pattern
histogram() { LC_ALL=C command grep -oh "$@" | LC_ALL=C sort | LC_ALL=C uniq -c; }

# Package maintenance on Ubuntu
alias up='sudo apt update && sudo apt full-upgrade --auto-remove --purge -y'

# Check status of all Git repos
gst() { find "$1" -type d -name .git -exec git --git-dir {} --work-tree {}/.. status \;; }

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='command git --git-dir ~/.cfg.git --work-tree ~'
alias cfg-plug='cfg submodule update --init --recursive --remote --depth 1 && command vim -es +helptags\ ALL +q #'
alias cfg-edit='GIT_DIR=~/.cfg.git "$VISUAL"'

# Install configs for Windows Terminal (from WSL)
cfg_wt() {
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

# Store private or machine-local .bashrc separately
[ -f ~/.config/bash/bashrc ] && . ~/.config/bash/bashrc

# Enable Node Version Manager if installed
[ -d ~/.nvm ] && . ~/.nvm/nvm.sh && . ~/.nvm/bash_completion

# Enable fzf shell integration if using local install
fzf=~/.vim/pack/plugins/start/fzf
case $(command -v fzf) in $fzf/*)
	. "$fzf"/shell/completion.bash
	. "$fzf"/shell/key-bindings.bash
esac
unset fzf

# Find bash completions and PS1 helper for system Git
# Supports macOS and FreeBSD; usually not needed for Windows or Linux
for d in \
	/Library/Developer/CommandLineTools/usr/share/git-core \
	/usr/local/share/git-core/contrib/completion
do
	if [ -d "$d" ]
	then
		. "$d"/git-completion.bash
		. "$d"/git-prompt.sh
		break
	fi
done

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
	for _ in $(jobs -p); do : $((++_njobs)); done
	[ $_njobs ] && _njobs="[$_njobs] "
}

# Clear gap between command output and shell prompt
PS1='\n'
# Set title to basename of current directory
PS1=$PS1'\[\e];\W\a\]'
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

# Interactive-friendly settings; see also .inputrc
# Should be at end of .bashrc to avoid conflicting with prior shell init code
if [ ${BASH_VERSION+x} ]
then
	shopt -s autocd
	shopt -s globstar failglob
	shopt -s no_empty_cmd_completion direxpand
	shopt -s checkjobs
	shopt -s histappend

	HISTTIMEFORMAT='%x %X  '
	HISTCONTROL=ignoreboth:erasedups

	# Make HISTFILESIZE use the default ($HISTSIZE, which we set to unlimited)
	HISTSIZE=
	unset HISTFILESIZE

	# Must come after any shell init code where HISTFILESIZE is set
	HISTFILE=~/.bash_history_eternal
fi
