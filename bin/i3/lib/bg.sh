WALLPAPER_DIR="$HOME/sync/wallpapers"
WALLPAPER_CACHE_BASE_DIR="$HOME/.cache/wallpapers"

_i3_bg_screen_resolution=''

function get_wallpaper_cache_dir() {
    _set_screen_resolution
    echo "${WALLPAPER_CACHE_BASE_DIR}/${_i3_bg_screen_resolution}/${WALLPAPER}"
}

function get_wallpaper_path() {
    _set_screen_resolution
    echo "${WALLPAPER_DIR}/${_i3_bg_screen_resolution}/${WALLPAPER}"
}

function _set_screen_resolution() {
    _i3_bg_screen_resolution=$("$DOTFILE_DIR/bin/gui/screen-resolution")
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

    if [[ "$output" =~ ([^\s]+)\ ([0-9]+)\ ([0-9]+)\ ([0-9]+)\ ([0-9]+) ]]; then
        local output_name=${match[1]}
        local x=${match[2]}
        local y=${match[3]}
        local width=${match[4]}
        local height=${match[5]}

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
