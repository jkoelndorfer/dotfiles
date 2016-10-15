#!/usr/bin/env zsh

vim_path="$(which vim 2>/dev/null)"
nvim_path="$(which nvim 2>/dev/null)"
if [[ -n "$nvim_path" ]]; then
    alias vi="$nvim_path"
    alias vim="$nvim_path"
    export EDITOR="$nvim_path"
elif [[ -n "$vim_path" ]]; then
    alias vi="$vim_path"
    export EDITOR="$vim_path"
fi
export VISUAL="$EDITOR"
