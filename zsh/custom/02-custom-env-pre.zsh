#!/usr/bin/env zsh

for e in $custom_env; do
    env_file="$ZSH_CUSTOM/custom-env/${e}-pre.zsh"
    [[ -f "$env_file" ]] && source "$env_file"
done
