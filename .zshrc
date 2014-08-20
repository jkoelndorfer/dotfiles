#!/bin/zsh
DEFAULT_UMASK=0022
umask $DEFAULT_UMASK

setopt noclobber
setopt sharehistory
setopt vi
autoload colors; colors
autoload -U compinit; compinit
zmodload zsh/zutil
zmodload zsh/complist
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' hosts off
zstyle ':completion:*:*:kill:*' verbose yes
zstyle ':completion:*:processes' command ps -u $USER -o pid,args --sort pid
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:list' yes

function __git_files {
    _wanted files expl 'local files' _files
}

function mintty_title {
    echo -ne "\033]2;"$1"\007"
}

function user_color {
    if [[ $UID = "0" ]]; then
        echo 'red'
    elif ! getent passwd "$(whoami)" | awk -F: '{ print $5 }' | grep -i -q 'John'; then
        echo 'yellow'
    else
        echo 'green'
    fi
}

PROMPT="[%D{%Y-%m-%d %T}] %F{$(user_color)}%n%f @ %B%m:%b%F{blue}%~ %f
%# "
export SUDO_PROMPT="[sudo] password for %p: "
export WINEARCH="win32"
export EDITOR="vim"
export VISUAL=$EDITOR
export PAGER="less"
export LANG="en_US.UTF-8"
export LESS="-R"
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export PATH="$HOME/bin:/bin:/usr/bin:/sbin:/usr/sbin"

if [[ "$(uname)" == "Linux" ]]; then
    export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l)"
fi

if [[ -n "$(env | grep KDE)" ]]; then
    export GTK2_RC_FILES=$HOME/.themes/kde4/gtk-2.0/gtkrc
fi

cygwin="$(/bin/uname -a | /bin/grep CYGWIN)"
if [[ -n "$cygwin" ]]; then
    export PATH="$PATH:/cygdrive/c/Windows/System32"
    # Set solarized colors for mintty
    echo -ne "\e]10;#839496\a" # foreground
    echo -ne "\e]11;#002B36\a" # background
    echo -ne "\e]12;#FFFFFF\a" # cursor
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

which ssh-agent-persistent >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    eval "$(ssh-agent-persistent)"
fi

alias ack="ack --color --pager='$PAGER'"
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias rm='rm -i'
# yum uses a different cache for users and root.  It does not make sense to
# maintain two caches, so use `sudo yum` instead.
alias yum='sudo yum'

alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gc='git commit'

if [[ $TERM = "linux" ]]; then
    alias tmux="tmux -L 8color"
fi
