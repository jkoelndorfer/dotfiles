# Time, in minutes, before xautolock will lock the screen.
export SCREENLOCK_TIME_MINUTES=15

# Time, in seconds, after which the mouse cursor will be hidden
# if the mouse is not moved.
export CURSOR_HIDE_TIME_SECONDS=5

x11_resolution=$("$DOTFILE_DIR/bin/x11/scrres" 2>/dev/null)
x11_y_resolution=$(echo "$x11_resolution" | awk -F x '{ print $2 }')

# DISPLAY_PROFILE indicates what sort of monitor(s) our session will be displayed on.
# This controls the size of many UI elements to optimize usability, particularly
# on very high DPI displays.
#
# Valid values are:
#
# HD:  1080p, 1440p, or similar
# UHD: 4K
if [[ "$x11_y_resolution" -le 1440 ]]; then
    DISPLAY_PROFILE='HD'
else
    DISPLAY_PROFILE='UHD'
fi
export DISPLAY_PROFILE

if [[ -n "$x11_resolution" ]]; then
    wallpaper_file="$HOME/sync/wallpapers/$x11_resolution/rootaccess.png"
fi
if [[ -n "$wallpaper_file" && -f "$wallpaper_file" ]]; then
    export WALLPAPER="$wallpaper_file"
    export WALLPAPER_BLURRED="$HOME/.cache/wallpaper/$(basename "$WALLPAPER" .png).png"
fi
