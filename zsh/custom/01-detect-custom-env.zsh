#!/usr/bin/env zsh

typeset -p custom_env &> /dev/null || custom_env=()

[[ -f '/etc/openwrt_release' ]] && custom_env+=('openwrt')
hostname -f | grep -q 'zipnosis.com$' && custom_env+=('zipnosis')
[[ "$(hostname -f)" = 'Johns-MacBook-Pro.local' ]] && custom_env+=('zipnosis')
