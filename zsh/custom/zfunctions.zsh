function ssh_intelligent {
    if echo "$@" | grep -q 'feralas'; then
        TERM=xterm \ssh $@
    fi
    \ssh $@
}

alias ssh='ssh_intelligent'
