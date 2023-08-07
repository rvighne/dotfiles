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

# Colors and human-readable sizes for iproute2
alias ip='ip -color=auto -h'

# Human-readable sizes in various tools
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Show full cmdline and PID in pstree
alias pstree='pstree -ap'

# Make bc useful as interactive calculator
alias bc='bc -ql'

# Use same diff implementation in or out of Git repo
alias diff='git diff --no-index --no-textconv --no-ext-diff'

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

# Generate secure random passwords
alias pw='tr -dc \[:graph:] </dev/urandom | fold -b -w12 | head -n'

# Count unique instances of a pattern
hist() { LC_ALL=C sort | LC_ALL=C uniq -c; }

# Package maintenance on Ubuntu
alias up='sudo apt update && sudo apt full-upgrade --auto-remove --purge -y'

# Check status of all Git repos
gst() { find "$1" -type d -name .git -exec git --git-dir {} --work-tree {}/.. status \;; }

# Make TUI programs work on Windows
if command -v winpty >/dev/null
then
	alias pp='pipenv run winpty python'
	alias python='winpty python'
	alias stack='winpty stack'
	alias latexmk='winpty latexmk'
fi

# Not all distros make this symlink
alias fd=fdfind

# Start ssh-agent with a known path so we don't need a .env file
alias start_agent='ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null'

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='git --git-dir ~/.cfg.git --work-tree ~'
alias cfg-edit='GIT_DIR=~/.cfg.git "$VISUAL"'

# Fetch Vim plugins and rebuild helptags
cfg_plug() {
	cfg submodule update --init --recursive --remote --depth 1 || return
	command vim -es +'helptags ALL' +q || true
}
