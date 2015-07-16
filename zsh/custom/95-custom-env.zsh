#!/usr/bin/env zsh

# This script detects specialized environments and runs sources settings to
# configure as appropriate.

[[ -f '/etc/openwrt_release' ]] && source $ZSH_CUSTOM/custom-env/openwrt.zsh

hostname -f | grep -q 'zipnosis.com$' && source $ZSH_CUSTOM/custom-env/zipnosis.zsh
