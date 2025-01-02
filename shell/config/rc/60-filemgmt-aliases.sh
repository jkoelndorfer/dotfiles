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

function extract-archive() {
    local archive_path=$1

    local file_mime_type=$(file --brief --mime-type "$archive_path")

    case "$file_mime_type" in
        application/zip)
            unzip "$archive_path"
            ;;
        application/x-7z-compressed)
            7z x "$archive_path"
            ;;
        application/x-rar)
            unrar x "$archive_path"
            ;;
        application/x-xz)
            xz --decompress "$archive_path"
            ;;
        *)
            echo "unrecognized archive type: $file_mime_type"
            return 1
            ;;
    esac
}

function x() {
    extract-archive "$@"
}

# Returns the path to the most recently modified file in the Downloads
# directory, i.e. the last downloaded file.
function get-last-dl() {
    local download_dir="$HOME/Downloads"
    find "$download_dir" -type f -printf "%T@\t%p\n" | sort -k1 -rn | head -n1 | awk -F"$(printf '\t')" '{ print $2 }'
}

function mv-last-dl() {
    local dest=$1

    local last_dl_file=$(get-last-dl)
    mv "$last_dl_file" "$dest"
}
