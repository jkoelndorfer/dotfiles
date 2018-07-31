#!/usr/bin/env zsh

# Only attempts to display an rvm prompt if rvm-prompt can be found
function prompt_rvm_conditional {
    if which rvm-prompt > /dev/null 2>&1; then
        prompt_rvm "$@"
    fi
}

function prompt_elements {
    elements=(context)
    elements+=(dir vcs time status)
    echo $elements
}

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
plugins=(git)
POWERLEVEL9K_MODE='compatible'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=($(prompt_elements))
POWERLEVEL9K_DISABLE_RPROMPT='true'
POWERLEVEL9K_PROMPT_ON_NEWLINE='true'
POWERLEVEL9K_TIME_FORMAT='%D{%F %H:%M:%S}'
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%# '
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY='truncate_to_last'

# Some applications that start a shell but don't allocate a TTY
# cause powerlevel9k to spit errors, so let's not load the theme
# if that happens.
if tty &> /dev/null; then
    ZSH_THEME="powerlevel9k"
fi
