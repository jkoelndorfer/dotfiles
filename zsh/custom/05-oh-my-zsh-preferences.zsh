#!/usr/bin/env zsh

# Only attempts to display an rvm prompt if rvm-prompt can be found
function prompt_rvm_conditional {
    if which rvm-prompt > /dev/null 2>&1; then
        prompt_rvm "$@"
    fi
}

function prompt_elements {
    elements=(context)
    if [[ -n "${custom_env[(r)zipnosis]}" ]]; then
        elements+=(zipnosis_env)
    fi
    elements+=(dir vcs rbenv rvm_conditional time longstatus)
    echo $elements
}

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
plugins=(git)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=($(prompt_elements))
POWERLEVEL9K_DISABLE_RPROMPT='true'
POWERLEVEL9K_PROMPT_ON_NEWLINE='true'
# Need to make this string non-empty so it doesn't get overridden by powerlevel9k
# defaults, but also don't want a prefix. A null byte does the job. :-)
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="$(echo -ne "\0")"
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='%# '
POWERLEVEL9K_TIME_FORMAT='%D{%F %H:%M:%S}'
ZSH_THEME="powerlevel9k"
