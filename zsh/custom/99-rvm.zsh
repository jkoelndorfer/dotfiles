#!/usr/bin/zsh

for p in '/etc/profile.d/rvm.sh' "$REALHOME/.rvm/scripts/rvm"; do
    [[ -f "$p" ]] && source "$p"
done

rvm use default > /dev/null 2>&1
