#!/bin/bash

DEFAULT_UMASK=0077
umask $DEFAULT_UMASK
set -o vi
shopt -s checkwinsize

PS1='[\u@\h \W]\$ '
PS2='> '
PS3='> '
PS4='+ '
export PS1 PS2 PS3 PS4

if [[ $TERM = "rxvt-unicode" ]]; then
	export TERM="xterm"
fi

alias ls='ls --color=auto'
alias rdesktop='rdesktop -K'
alias svim='sudo vim -u ~/.vimrc'
alias bnpw='pwsafe -p gaming.battle.net'
alias sru="sync-usb ~/repos /media/jkusb/repos"
