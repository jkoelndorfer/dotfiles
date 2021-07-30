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
