#!/bin/zsh
DEFAULT_UMASK=0022
umask $DEFAULT_UMASK

LS_COLORS='rs=0:di=00;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=00;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

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
export VIM_BUNDLE_DIR="$HOME/.vim/bundle"

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
alias ls='ls --color=auto --group-directories-first'
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
