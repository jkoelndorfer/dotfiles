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
        (find $search_path -mindepth 0 ${maxdepth_arg[@]} -type d 2>/dev/null;
            [[ -n "${addl_search_paths[@]}" ]] && echo "${addl_search_paths[@]}") |
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
