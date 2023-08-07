# Colors, type indicators, and human-readable sizes in ls
alias ls='ls --color=auto -hF'
alias la='ls -A'
alias ll='ls -la'

# Show brief directory listing on directory change
command -v timeout >/dev/null && cd() {
	command cd "$@" || return
	timeout .025s ls --color=auto -hF || true
}

# Colors for grep
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

# Package maintenance on Ubuntu
alias up='sudo apt update && sudo apt full-upgrade --auto-remove --purge -y'

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
