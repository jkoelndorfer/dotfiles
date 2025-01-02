if [[ "$SHELL_NAME" == 'bash' ]]; then
    shopt extglob >/dev/null 2>&1
elif [[ "$SHELL_NAME" == 'zsh' ]]; then
    setopt EXTENDED_GLOB
fi

export PAGER='less'
export LESS='-R'

if [[ "$SHELL_NAME" == 'bash' ]]; then
    export HISTFILE="$HOME/.bash_history"
elif [[ "$SHELL_NAME" == 'zsh' ]]; then
    export HISTFILE="$HOME/.zhistory"
fi

export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

set -o vi

if [[ "$SHELL_NAME" == 'zsh' ]]; then
    # Per https://dougblack.io/words/zsh-vi-mode.html:
    #
    # By default, there is a 0.4 second delay after you hit the <ESC> key and when
    # the [zsh vi mode] change is registered.
    #
    #
    # KEYTIMEOUT=1 reduces the delay to 0.1 seconds.
    export KEYTIMEOUT=1
fi
