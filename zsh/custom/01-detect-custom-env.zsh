#!/usr/bin/env zsh

typeset -p custom_env &> /dev/null || custom_env=()

[[ -f '/etc/openwrt_release' ]] && custom_env+=('openwrt')
hostname -f | grep -q 'zipnosis.com$' && custom_env+=('zipnosis')
[[ "$TERM" == "linux" ]] && custom_env+=('linuxvt')
[[ "$MINTTY" == "1" ]] && custom_env+=('mintty')
[[ "$PIPENV_ACTIVE" == "1" ]] && custom_env+=('pipenv')
