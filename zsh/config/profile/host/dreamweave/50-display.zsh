# FIXME: This is a temporary hack to support different
# display names under Wayland and X11.
#
# This is not a good solution. Install-time configuration
# depends on the values of these variables, so installing
# Wayland configuration will be broken when installing in
# an X11 session and vice-versa.
#
# Perhaps something like
#
# DISPLAYNAME_WAYLAND_RIGHT, DISPLAYNAME_X11_RIGHT for install-time
# configurations and DISPLAYNAME_RIGHT for anything at runtime?
#
# Need to think more on it.
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    export DISPLAYNAME_LEFT='DP-1'
    export DISPLAYNAME_CENTER='DP-2'
    export DISPLAYNAME_RIGHT='DP-3'
else
    export DISPLAYNAME_LEFT='DisplayPort-0'
    export DISPLAYNAME_CENTER='DisplayPort-1'
    export DISPLAYNAME_RIGHT='DisplayPort-2'
fi
export SCREENSAVER_STRATEGY='screen-off'
