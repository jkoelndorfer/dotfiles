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
if [[ "$(uname)" == "Linux" ]]; then
	export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l)"
fi
