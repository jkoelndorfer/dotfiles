setopt EXTENDED_GLOB

export EDITOR='vi'
export VISUAL="$EDITOR"

export PAGER='less'
export LESS='-R'

export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

set -o vi
# Per https://dougblack.io/words/zsh-vi-mode.html:
#
# By default, there is a 0.4 second delay after you hit the <ESC> key and when
# the [zsh vi mode] change is registered.
#
#
# KEYTIMEOUT=1 reduces the delay to 0.1 seconds.
export KEYTIMEOUT=1

c_search_directories=("${c_search_directories[@]}" "$HOME/projects" "$HOME/src" "$HOME/src/bigcommerce")
