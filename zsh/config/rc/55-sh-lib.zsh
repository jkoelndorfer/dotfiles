function c() {
    cd "$(selectdir "$1")"
}

function selectdir() {
    local search_path=("$1")
    local addl_search_paths=''
    local maxdepth_arg=(-maxdepth 1)
    if [[ -z "$search_path" ]]; then
        search_path=(${c_default_search_directories[@]})
        addl_search_paths=("${c_addl_directories[@]}")
    else
        maxdepth_arg=()
    fi
    local selected_dir="$(
        (find $search_path -type d -mindepth 0 ${maxdepth_arg[@]} 2>/dev/null; echo "${addl_search_paths[@]}") |
            grep -Ev '/.git(/|$)' | sort -u |
            fzf --preview 'tree -C -L 1 {}' --ansi
    )"
    [[ -n "$selected_dir" ]] && echo "$selected_dir"
}

