# Prints every directory above "$dir" up to /.
function dir_hier_up() {
    local dir="${1-.}"

    local orig_dirs="$(dirs)"
    if ! pushd "$dir" >/dev/null 2>&1; then
        return 1
    fi

    # The look below won't include "/", so we'll include it
    # ourselves as a special case.
    echo '/'
    while [[ "$PWD" != '/' ]]; do
        echo "$PWD"
        pushd ".." >/dev/null 2>&1
    done | tac

    while [[ "$(dirs)" != "$orig_dirs" ]]; do
        popd >/dev/null 2>&1
    done
}

function dir_hier_down() {
    local dir=${1-.}

    {
        find "$dir" -type d -print0 | xargs -0 realpath | grep -Ev '/\.git/'
    } 2>/dev/null
}

function up() {
    local selected_dir=$(dir_hier_up | fzf)

    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
    else
        return 1
    fi
}

function down() {
    local selected_dir=$(dir_hier_down | fzf)

    if [[ -n "$selected_dir" ]]; then
        cd "$selected_dir"
    else
        return 1
    fi
}
