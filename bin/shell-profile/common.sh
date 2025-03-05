function nonshprofile_cmd() {
    local cmd=$1; shift

    while read p; do
        if [[ "$p" != "$SHELL_PROFILE_DIR/"* ]]; then
            echo "$p"
            break
        fi
    done <<< "$(which -a "$cmd" 2>/dev/null)"
}

function nonshprofile() {
    local cmd=$1; shift
    local cmd_to_exec=$(nonshprofile_cmd "$cmd")

    if [[ -n "$cmd_to_exec" ]]; then
        exec "$cmd_to_exec" "$@"
    else
        echo "$0: could not find non shell-profile executable for $cmd" >&2
        return 1
    fi
}
