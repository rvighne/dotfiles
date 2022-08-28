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

# Make bc useful as interactive calculator
alias bc='bc -ql'

# Atomic make-and-change-to directory
mkcd() { mkdir -p -- "$@" && command cd -- "$1"; }

# Show all my own processes (useful over SSH)
pt() { pstree "$@" -- "$USER"; }

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

# Git for the dotfiles repo
# Warning: does NOT protect against git-clean
alias cfg='git --git-dir ~/.cfg.git --work-tree ~'
alias cfg-edit='GIT_DIR=~/.cfg.git "$VISUAL"'

# Fetch Vim plugins and rebuild helptags
cfg_plug() {
	cfg submodule update --init --recursive --remote --depth 1 || return
	command vim -es +'helptags ALL' +q || true
}

# Install configs for Windows Terminal (from WSL)
cfg_wt() {
	local wdst=$(wslvar LOCALAPPDATA)'\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\'
	local ldst=$(wslpath -- "$wdst")
	cp -- ~/.config/wt/settings.json "$ldst"
}
