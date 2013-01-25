#!/bin/zsh

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
   export PATH="$HOME/bin:$PATH"
fi

if [[ -n "$(env | grep KDE)" ]]; then
	export GTK2_RC_FILES=$HOME/.themes/kde4/gtk-2.0/gtkrc
fi
export PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
export SUDO_PROMPT="[sudo] password for %p: "
export WINEARCH="win32"
export EDITOR="vim"
export VISUAL=$EDITOR
export PAGER="less"
export LESS="-R"
export JAVA_HOME="/usr/lib/jvm/java-6-sun/"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
if [[ "$(uname)" == "Linux" ]]; then
	export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l)"
fi
