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

# Idempotent and machine-local parts of bashrc are stored separately
for rc in ~/.config/bash/*bashrc; do if [ -O "$rc" ]; then . "$rc"; fi; done

# Integrate fzf with bash (e.g. for history search) if installed
command -v fzf >/dev/null && . ~/.vim/pack/plugins/start/fzf/shell/key-bindings.bash

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
