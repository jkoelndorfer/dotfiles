function bw() {
    local bw_output
    if [[ "$1" == 'unlock' ]]; then
        bw_output=$(command bw "$@" --raw)
        rc=$?
        if [[ -n "$bw_output" ]]; then
            export BW_SESSION=$bw_output
        fi
        return "$rc"
    fi
    command bw "$@"
}

function sudo() {
    command sudo \
        --preserve-env=DOTFILE_DIR \
        --preserve-env=SHELL_PROFILE_DIR \
        "$@"
}

function weather() {
    curl wttr.in/"$1"
}
