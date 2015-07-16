#!/usr/bin/zsh

rvm_profile_path='/etc/profile.d/rvm.sh'

[[ -f "$rvm_profile_path" ]] && source "$rvm_profile_path"
