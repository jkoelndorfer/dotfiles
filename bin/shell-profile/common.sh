function nonshprofile() {
    local cmd=$1; shift

    local found_cmd=0
    while read p; do
        if [[ "$p" != "$SHELL_PROFILE_DIR/"* ]]; then
            found_cmd=1
            break
        fi
    done <<< "$(which -a "$cmd")"
    if [[ "$found_cmd" == '1' ]]; then
        exec "$p" "$@"
    else
        echo "$0: could not find non shell-profile executable for $cmd" >&2
        return 1
    fi
}
