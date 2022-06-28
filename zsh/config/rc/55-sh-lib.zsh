function c() {
    cd "$(selectdir "$1")"
}

function confirm-cmd() {
    local description=$1
    local confirm_response='unset'

    shift
    local cmd=("$@")

    while [[ "$confirm_response" == 'unset' ]]; do
        read -r "confirm_response?${description}? [Y/N] "
        case "$(echo "$confirm_response" | tr '[:upper:]' '[:lower:]')" in
            y|yes|true|1)
                confirm_response=1
                ;;
            n|no|false|0)
                confirm_response=0
                ;;
            *)
                echo "Invalid response '$confirm_response'" >&2
                confirm_response='unset'
        esac
    done
    if [[ "$confirm_response" == '1' ]]; then
        "${(@)cmd}"
    else
        return 121
    fi
}

function selectdir() {
    local search_path=()
    local addl_paths=()
    local maxdepth_arg=(-maxdepth 1)
    if [[ -z "$1" ]]; then
        search_path=("${c_search_directories[@]}")
        addl_paths=("$DOTFILE_DIR")
    else
        if ! [[ -e "$1" ]]; then
            echo "$0: no such file or directory: $1" >&2
            return 1
        elif ! [[ -d "$1" ]]; then
            echo "$0: not a directory: $1" >&2
            return 1
        else
            local search_path=("$(readlink -f "$1")")
            maxdepth_arg=()
        fi
    fi
    local selected_dir="$(
        (
            find "${search_path[@]}" -mindepth 0 "${maxdepth_arg[@]}" -type d 2>/dev/null;
            for d in "${addl_paths[@]}"; do echo "$d"; done
        ) |
        grep -Ev '/.git(/|$)|^\.$' | sort -u |
        fzf --preview 'tree -C -L 1 {}' --ansi
    )"
    [[ -n "$selected_dir" ]] && echo "$selected_dir"
}

function trim-string() {
    sed -r -e 's/(^\s+|\s+$)//g'
}

function value-or-cmd() {
    local value=$1
    shift
    if [[ -z "$value" ]]; then
        "$@"
    fi
}

# Searches parent directories for at least one of the listed files.
# If one of the files exists, the path is printed and the return
# code is 0. If the file is not found, the return code is 1.
function search-upwards-for-one-of() {
    local original_dir="$PWD"

    while [[ "$PWD" != '/' ]]; do
        for f in "$@"; do
            if [[ -f "$f" ]]; then
                echo "$PWD/$f"
                cd "$original_dir"
                return 0
            fi
        done
        cd ..
    done
    cd "$original_dir"
    return 1
}
