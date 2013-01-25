#!/bin/zsh
DEFAULT_UMASK=0077
umask $DEFAULT_UMASK

setopt noclobber
autoload colors; colors
autoload -U compinit; compinit
zmodload zsh/zutil
zmodload zsh/complist

function __git_files {
	_wanted files expl 'local files' _files
}

function nup {
	find ~/repos -type l 2>/dev/null | while read r; do
		# Don't show untracked files in the home repo
		if [[ -n "$(echo "$r" | grep 'home$')" ]]; then
			GIT_STATUS_FLAGS="-uno"
		else
			GIT_STATUS_FLAGS=""
		fi
		if [[ -d "$r/.git" && ! -z $(cd $r; git status $GIT_STATUS_FLAGS -s 2>/dev/null) ]]; then
			echo "$r" | sed -e "s#$HOME/##"
		fi
	done
}

set -o vi

which ssh-agent-persistent >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
	eval "$(ssh-agent-persistent)"
fi

if [[ $UID = "0" ]]; then
	USERNAMECOLOR="red"
else
	USERNAMECOLOR="green"
fi

HOSTNAME="$(hostname)"
if [[ ! -z "$(uname -a | grep CYGWIN)" ]]; then
	HOSTNAME="${HOSTNAME}-WIN"
	# Set PATH to include system32
	PATH="$PATH:/cygdrive/c/Windows/System32"
	# Set solarized colors for mintty
	echo -ne "\e]P0073642\a"
	echo -ne "\e]P8002b36\a"
	echo -ne "\e]P1dc322f\a"
	echo -ne "\e]P9cb4b16\a"
	echo -ne "\e]P2859900\a"
	echo -ne "\e]PA586e75\a"
	echo -ne "\e]P3b58900\a"
	echo -ne "\e]PB657b83\a"
	echo -ne "\e]P4268bd2\a"
	echo -ne "\e]PC839496\a"
	echo -ne "\e]P5d33682\a"
	echo -ne "\e]PD6c71c4\a"
	echo -ne "\e]P62aa198\a"
	echo -ne "\e]PE93a1a1\a"
	echo -ne "\e]P7eee8d5\a"
	echo -ne "\e]PFfdf6e3\a"
fi

PROMPT="[%D{%Y/%m/%d %T}] %F{$USERNAMECOLOR}%n%f @ %B$HOSTNAME:%b%F{blue}%~ %f
%# "

alias ack="ack --color --pager='$PAGER'"
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias rm='rm -i'
# yum uses a different cache for users and root.  It does not make sense to
# maintain two caches, so use `sudo yum` instead.
alias yum='sudo yum'
alias gminix='ssh -tY xterm1.genmills.com "tmux attach -t gmi || tmux new -s gmi"'

if [[ $TERM = "linux" ]]; then
	alias tmux="tmux -L 8color"
fi

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' hosts off
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:processes' command ps -u $USER -o pid,args --sort pid
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:list' yes
