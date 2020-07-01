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

function weather() {
    curl wttr.in/"$1"
}
