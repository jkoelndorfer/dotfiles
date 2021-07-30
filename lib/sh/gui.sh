# If using this in a shell script to find other instances of itself running,
# be sure to loop over pids like so:
#
# while read pid; do
#     # do stuff
# done <<< "$(get_processes_in_display ...)"
#
function get_processes_in_display() {
    local process=$1

    if [[ -z "$process" ]]; then
        echo "$0: must supply process name as first argument" >&2
        return 1
    fi

    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        display_var='WAYLAND_DISPLAY'
        current_display="$WAYLAND_DISPLAY"
    elif [[ -n "$DISPLAY" ]]; then
        display_var='DISPLAY'
        current_display="$DISPLAY"
    else
        echo "$0: unable to determine appropriate display" >&2
        return 1
    fi

    while read pid; do
        if [[ -z "$pid" ]]; then
            continue
        fi
        local proc_display=$(
            cat "/proc/$pid/environ" |
            xargs -0 -n1 echo |
            awk -F= '$1 == "'"$display_var"'" { print $2 }'
        )
        if [[ "$proc_display" == "$current_display" ]]; then
            echo "$pid"
        fi
    done <<< "$(pgrep -x -u "$UID" "$(basename "$process")")"
}

# This function kills processes which are running underneath the
# current $DISPLAY or $WAYLAND_DISPLAY, as appropriate.
#
# The use case is to provide an easy way to kill session-specific
# daemons, like dunst, xss-lock, or polybar, so that they can
# be restarted.
function kill_processes_in_display() {
    local process=$1

    while read pid; do
        if [[ "$pid" == "$$" || -z "$pid" ]]; then
            continue
        fi
        kill "$pid"
    done <<< "$(get_processes_in_display "$process")"
}

function get_sway_outputs() {
    local output_info=$(swaymsg -t get_outputs | jq '[.[] | {name: .name, rect: .rect}]')
    local num_outputs=$(echo "$output_info" | jq 'length')

    for i in $(seq 0 $((num_outputs - 1))); do
        echo "$output_info" |
        jq -r ".[$i] | [.name, .rect.x, .rect.y, .rect.width, .rect.height] | join(\" \")"
    done
}

function output_info() {
    local info=$1
    local output=$2

    if [[ -z "$info" ]]; then
        echo "$0: must specify desired output info" >&2
        return 1
    fi
    if [[ -z "$output" ]]; then
        echo "$0: must provide output data for a single output, as from get_sway_outputs" >&2
        return 2
    fi

    if [[ "$output" =~ ([^\s]+)\ ([0-9]+)\ ([0-9]+)\ ([0-9]+)\ ([0-9]+) ]]; then
        if [[ -n "$ZSH_VERSION" ]]; then
            local matcher=("${match[@]}")
        elif [[ -n "$BASH_VERSION" ]]; then
            local matcher=("${BASH_REMATCH[@]}")
        fi
        local output_name=${matcher[1]}
        local x=${matcher[2]}
        local y=${matcher[3]}
        local width=${matcher[4]}
        local height=${matcher[5]}

        local crop_parameters="${width}x${height}+${x}+${y}"

        if [[ "$info" == 'bg-crop-parameters' ]]; then
            echo "$crop_parameters"
        elif [[ "$info" == 'bg-path' ]]; then
            echo "$(get_wallpaper_cache_dir)/${WALLPAPER}_${crop_parameters}"
        elif [[ "$info" == 'blurred-bg-path' ]]; then
            echo "$(get_wallpaper_cache_dir)/${WALLPAPER}_${crop_parameters}_blurred"
        elif [[ "$info" == 'output-name' ]]; then
            echo "$output_name"
        else
            echo "$0: unrecognized info '$info'" >&2
            return 2
        fi
    else
        return 1
    fi
}
