function c() {
    cd "$(selectdir "$1")"
}

function selectdir() {
    search_path=("$1")
    if [[ -z "$search_path" ]]; then
        search_path=(${c_default_search_directories[@]})
        maxdepth_arg=(-maxdepth 1)
    else
        maxdepth_arg=()
    fi
    echo "$(
        find $search_path -type d -mindepth 0 ${maxdepth_arg[@]} 2>/dev/null |
            grep -Ev '/.git(/|$)' | sort -u |
            fzf --preview 'tree -C -L 1 {}' --ansi
    )"
}

