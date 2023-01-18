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
