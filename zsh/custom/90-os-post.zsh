#!/usr/bin/env zsh

scriptpath="$ZSH_CUSTOM/os/${OS}-post.zsh"
[[ -f "$scriptpath" ]] && source "$scriptpath"
