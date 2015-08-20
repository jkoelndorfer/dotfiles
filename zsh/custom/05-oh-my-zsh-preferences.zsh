#!/usr/bin/env zsh

function prompt_elements {
    elements=(context)
    if [[ -n "${custom_env[(r)zipnosis]}" ]]; then
        elements+=(zipnosis_env)
    fi
    elements+=(dir vcs rbenv)
    if which rvm-prompt > /dev/null 2>&1; then
        elements+=(rvm)
    fi
    elements+=(time longstatus)
    echo $elements
}

DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
plugins=(git)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=($(prompt_elements))
POWERLEVEL9K_PROMPT_ON_NEWLINE='true'
POWERLEVEL9K_TIME_FORMAT='%D{%F %H:%M:%S}'
ZSH_THEME="powerlevel9k"
