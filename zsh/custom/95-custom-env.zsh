#!/usr/bin/env zsh

# This script detects specialized environments and runs sources settings to
# configure as appropriate.

[[ -f '/etc/openwrt_release' ]] && source $ZSH_CUSTOM/custom-env/openwrt.zsh
