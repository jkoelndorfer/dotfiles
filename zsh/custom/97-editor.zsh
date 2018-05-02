#!/usr/bin/env zsh

# This tells neovim not to change the terminal cursor, no matter what.
# Some poorly behaved neovim plugins may not abide by the guicursor
# setting. This is a way of forcibly fixing that.
#
# easymotion, I'm looking at you.
export VTE_VERSION=100

if which nvim >/dev/null 2>&1; then
    nvim_path="$(which nvim)"
fi
if which vim >/dev/null 2>&1; then
    vim_path="$(which vim 2>/dev/null)"
fi
if [[ -n "$nvim_path" ]]; then
    alias vi="$nvim_path"
    alias vim="$nvim_path"
    export EDITOR="$nvim_path"
elif [[ -n "$vim_path" ]]; then
    alias vi="$vim_path"
    export EDITOR="$vim_path"
fi
export VISUAL="$EDITOR"
