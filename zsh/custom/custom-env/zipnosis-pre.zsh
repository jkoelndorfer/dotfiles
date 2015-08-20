#!/bin/zsh

function zipnosis_env {
    if [[ "$(hostname -f)" =~ '\.([^.]+)\.zipnosis.com$' ]]; then
        echo "${match[1]}"
    elif [[ "$(hostname)" = 'Johns-MacBook-Pro.local' ]]; then
        echo 'local'
    elif [[ "$(whoami)" = 'vagrant' ]]; then
        echo 'vagrant'
    else
        echo 'unknown'
    fi
}

function zipnosis_env_color {
    env_name="$1"
    if [[ "$env_name" = 'local' || "$env_name" = 'vagrant' ]]; then
        echo 'green'
    elif echo "$env_name" | grep -E -q '^(demo|training)$'; then
        echo 'yellow'
    else
        echo 'red'
    fi
}

function prompt_zipnosis_env {
    side="$1"

    ${side}_prompt_segment "$DEFAULT_COLOR" "$(zipnosis_env_color "$(zipnosis_env)")" "$(zipnosis_env)"
}

export ZIPNOSIS_SOURCE="$REALHOME/src/zipnosis"
