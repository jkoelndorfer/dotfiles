function openmw-plugin-new() {
    local plugin_path=$1

    if [[ -z "$OPENMW_PLUGIN_ROOT" ]]; then
        printf '%s: error: $OPENMW_PLUGIN_ROOT must be set in the environment\n' "$0" >&2
        return 1
    fi

    if [[ -z "$plugin_path" ]]; then
        printf "$0: error: plugin path must be specified as first argument\n" >&2
        return 2
    fi

    local plugin_download_dir="$OPENMW_PLUGIN_ROOT/download/$plugin_path"
    local plugin_data_dir="$OPENMW_PLUGIN_ROOT/plugin-data/$plugin_path"

    mkdir -p "$plugin_download_dir" "$plugin_data_dir"

    local ref_file=$(mktemp --tmpdir "$0-ref.XXXXXX")
    printf "$0: download plugin files, then hit enter" >&2
    read
    cd "$plugin_data_dir" &>/dev/null

    local plugin_archives=$(find "$HOME/Downloads" -newer "$ref_file" -type f)
    while read f; do
        if [[ -z "$f" ]]; then
            continue
        fi
        printf "$0: processing plugin archive '%s'\n" "$(basename "$f")" >&2
        extract-archive "$f"
        mv "$f" "$plugin_download_dir"
    done <<< "$plugin_archives"

    rm -f "$ref_file"
    export _OPENMW_PLUGIN_SETUP=1
    find -type d
    printf "$0: reorganize mod files as required, and then run \`openmw-plugin-done\`\n" >&2
}

function openmw-plugin-done() {
    if [[ -z "$OPENMW_PLUGIN_ROOT" ]]; then
        printf '%s: error: $OPENMW_PLUGIN_ROOT must be set in the environment\n' "$0" >&2
        return 1
    fi
    if [[ "$_OPENMW_PLUGIN_SETUP" != '1' ]]; then
        printf "$0: error: openmw plugin setup not in progress\n" >&2
        return 2
    fi
    cd "$OPENMW_PLUGIN_ROOT"
    unset _OPENMW_PLUGIN_SETUP
}
