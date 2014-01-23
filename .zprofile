#!/bin/zsh

if [[ -n "$(env | grep KDE)" ]]; then
	export GTK2_RC_FILES=$HOME/.themes/kde4/gtk-2.0/gtkrc
fi
export SUDO_PROMPT="[sudo] password for %p: "
export WINEARCH="win32"
export EDITOR="vim"
export VISUAL=$EDITOR
export PAGER="less"
export LESS="-R"
export JAVA_HOME="/usr/lib/jvm/java-6-sun/"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export PATH="$HOME/bin:$PATH:$HOME/.rvm/bin"

if [[ "$(uname)" == "Linux" ]]; then
	export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l)"
fi

cygwin="$(/bin/uname -a | /bin/grep CYGWIN)"
if [[ -n "$cygwin" ]]; then
	export PATH="/bin:/usr/bin:/sbin:/usr/sbin:$PATH:/cygdrive/c/Windows/System32"
fi

which ssh-agent-persistent >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
	eval "$(ssh-agent-persistent)"
fi

# Load RVM if it exists
RVM="$HOME/.rvm/scripts/rvm"
[[ -s "$RVM" ]] && source "$RVM"
