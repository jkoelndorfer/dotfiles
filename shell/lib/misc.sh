function set-profile() {
    local profile_name=$1

    export SHELL_PROFILE=$profile_name
    export AWS_PROFILE=$profile_name
}

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

function go-project-dirs() {
    find "$HOME/src/go" -name go.mod -type f | sed -r -e 's#/go.mod##'
}

function selectdir() {
    local search_path=()
    local addl_paths=()
    local maxdepth_arg=(-maxdepth 1)
    if [[ -z "$1" ]]; then
        search_path=("${c_search_directories[@]}")
        addl_paths=("$DOTFILE_DIR")
        go-project-dirs | while read d; do
            addl_paths+=("$d")
        done
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

function genpw() {
    local length=$1
    local charset=$2

    if [[ -z "$charset" ]]; then
        charset='alnum'
    fi

    if ! [[ "$charset" =~ (alnum|alpha|digit|graph|xdigit) ]]; then
        {
            echo "Selected character set must be one of:"
            echo "alnum:  upper and lowercase letters, numbers"
            echo "alpha:  upper and lowercase letters"
            echo "digit:  numbers"
            echo "graph:  all printable characters (including special characters), not including space"
            echo "xdigit: upper and lowercase letters A-F, numbers"
        } >&2
        return 1
    fi

    LANG=C sed -r -e 's/[^ -~]//g' < /dev/urandom |
        tr -d -c "[:$charset:]" |
        head -c "$length"
}

function find-and-replace() {
    local search=$1
    local replace=$2
    local target=$3

    if [[ -z "$3" ]]; then
        target='.'
    fi

    local rs=$(echo -e '\x1e')
    local sed=sed

    # Mac's sed frequently causes me grief. It's not argument
    # compatible with GNU sed and cannot handle the record separator
    # character in a sed command.
    #
    # Ensure we always use GNU sed.
    if [[ "$(uname)" == 'Darwin' ]]; then
        sed=gsed
    fi
    find "$target" -type f -print0 |
        grep --invert-match -z -e '/.git/' -e '/.jj/' |
        xargs -0 "$sed" -r --in-place -e "s${rs}${search}${rs}${replace}${rs}g"
}

function sjoin() {
    local separator=$1
    shift
    (IFS="$separator"; echo "$*")
}

# Rename is like `mv`, but the target is relative to the current directory of src
function rename() {
    local src=$1
    local dest=$2

    if [[ "$#" -lt 2 ]]; then
        echo "$0: not enough arguments; expected src and dest" >&2
        return 1
    fi
    if [[ "$#" -gt 2 ]]; then
        echo "$0: too many arguments; expected src and dest" >&2
        return 1
    fi

    if ! [[ "$dest" =~ '^/' ]]; then
        # destination is not an absolute path; make it relative to src
        local src_dir=$(dirname "$src")
        dest="$src_dir/$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    mv "$src" "$dest"
}

function toutc() {
    local dt=$1

    local localdt_ts=$(date --date "$dt" '+%s')
    date --date "@${localdt_ts}" --utc '+%Y-%m-%d %H:%M:%SZ'
}

function urlencode() {
    local s=$1

    python3 -c 'import sys; from urllib.parse import quote; print(quote(sys.argv[1]), file=sys.stdout)' "$s"
}

function urldecode() {
    local url=$1

    python3 -c 'import sys; from urllib.parse import unquote; print(unquote(sys.argv[1]), file=sys.stdout)' "$url"
}

# Lists the names of all variables defined in the environment.
#
# There are some caveats. This was taken from https://unix.stackexchange.com/a/439174.
function ls-env-vars() {
    awk 'BEGIN { for(v in ENVIRON) print v }' | sort -u
}

# Executes a command verbosely (similar to set -x).
function v() {
    printf '+ %s\n' "$*" >&2
    "$@"
}
