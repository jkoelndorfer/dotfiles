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

    tr --delete --complement "[:$charset:]" < /dev/urandom | head -c "$length"
}

function find-and-replace() {
    local search=$1
    local replace=$2
    local target=$3

    if [[ -z "$3" ]]; then
        target='.'
    fi

    local rs=$(echo -e '\x1e')

    # GNU sed requires different arguments for in-place editing of files than
    # BSD sed. In particular, sed on macOS requires an empty argument to -i
    # while GNU sed complains if it receives one.
    local in_place_args=()
    if (sed --version 2>&1 || true) | grep -q 'GNU'; then
        in_place_args=('--in-place')
    else
        in_place_args=('-i' '')
    fi
    find "$target" -type f -print0 |
        grep --invert-match -z '/.git/' |
        xargs -0 sed -r "${in_place_args[@]}" -e "s${rs}${search}${rs}${replace}${rs}"
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

function urldecode() {
    local url=$1

    python3 -c 'import sys; from urllib.parse import unquote; print(unquote(sys.argv[1]), file=sys.stdout)' "$url"
}

function weather() {
    curl wttr.in/"$1"
}
