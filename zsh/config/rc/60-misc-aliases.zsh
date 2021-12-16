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
    find "$target" -type f -print0 |
        grep --invert-match -z '/.git/' |
        xargs -0 sed -r -i -e "s${rs}${search}${rs}${replace}${rs}"
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
