#!/usr/bin/env zsh

typeset -p custom_env &> /dev/null || custom_env=()

[[ -f '/etc/openwrt_release' ]] && custom_env+=('openwrt')
[[ "$TERM" == "linux" ]] && custom_env+=('linuxvt')
[[ "$MINTTY" == "1" ]] && custom_env+=('mintty')
[[ "$PIPENV_ACTIVE" == "1" ]] && custom_env+=('pipenv')
