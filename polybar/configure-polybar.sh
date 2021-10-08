#!/bin/bash

function discover_battery {
    for i in BAT0 BAT1; do
        local fp="/sys/class/power_supply/$i"
        if [[ -e "$fp" ]]; then
            echo "$i"
        fi
    done
}

function discover_power_adapter {
    for i in ACAD ADP1; do
        local fp="/sys/class/power_supply/$i"
        if [[ -e "$fp" ]]; then
            echo "$i"
        fi
    done
}

function discover_wifi_adapter {
    local network_ifaces=$(ip -o link show)
    local wl=$(echo "$network_ifaces" | awk '{ print $2 }' | sed -r -e 's/:$//' | grep '^wl')

    if [[ -n "$wl" ]]; then
        echo "$wl" | head -n 1
    fi
}

mkdir -p "$HOME/.config"
source "$DOTFILE_DIR/theme/$DESKTOP_THEME/colors"

optional_modules=()

COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR=${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR:-$COLORSCHEME_FG_SHADE_3}

COLORSCHEME_POLYBAR_BG_COLOR=${COLORSCHEME_POLYBAR_BG_COLOR:-$COLORSCHEME_BG_SHADE_1}
COLORSCHEME_POLYBAR_FG_COLOR=${COLORSCHEME_POLYBAR_FG_COLOR:-$COLORSCHEME_FG_SHADE_0}

COLORSCHEME_POLYBAR_BG_SELECTED_COLOR=${COLORSCHEME_POLYBAR_BG_SELECTED_COLOR:-$COLORSCHEME_BG_SHADE_3}
COLORSCHEME_POLYBAR_FG_SELECTED_COLOR=${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR:-$COLORSCHEME_FG_SHADE_0}

COLORSCHEME_POLYBAR_BG_URGENT_COLOR=${COLORSCHEME_POLYBAR_BG_URGENT_COLOR:-$COLORSCHEME_BG_SHADE_1}
COLORSCHEME_POLYBAR_FG_URGENT_COLOR=${COLORSCHEME_POLYBAR_FG_URGENT_COLOR:-$COLORSCHEME_FG_SHADE_0}
COLORSCHEME_POLYBAR_BG_URGENT_UNDERLINE_COLOR=${COLORSCHEME_POLYBAR_BG_URGENT_UNDERLINE_COLOR:-$COLORSCHEME_RED}

COLORSCHEME_POLYBAR_AUDIO_UNDERLINE_COLOR=${COLORSCHEME_POLYBAR_MUSIC_UNDERLINE_COLOR:-$COLORSCHEME_ACCENT1_SHADE_0}
COLORSCHEME_POLYBAR_MUSIC_UNDERLINE_COLOR=${COLORSCHEME_POLYBAR_MUSIC_UNDERLINE_COLOR:-$COLORSCHEME_ACCENT2_SHADE_0}

display_profile=$("$DOTFILE_DIR/bin/gui/display-profile")

if [[ "$display_profile" == 'UHD' ]]; then
    polybar_bar_height=36
    polybar_text_size=18
    polybar_icon_size=24
    polybar_ws_icon_size=24
    polybar_ws_icon_spacing=4
    polybar_ws_icon_underline_size=4
else
    polybar_bar_height=25
    polybar_text_size=12
    polybar_icon_size=12
    polybar_ws_icon_size=18
    polybar_ws_icon_spacing=2
    polybar_ws_icon_underline_size=2
fi
polybar_textfont="mononoki Nerd Font Mono:pixelsize=${polybar_text_size}"
polybar_iconfont="mononoki Nerd Font Mono:pixelsize=${polybar_icon_size};0"
polybar_wsiconfont="mononoki Nerd Font Mono:pixelsize=${polybar_ws_icon_size};${polybar_ws_icon_spacing}"

battery=$(discover_battery)
power_adapter=$(discover_power_adapter)

if [[ -n "$battery" ]]; then
    optional_modules=(${optional_modules[@]} 'battery')
fi

wifi=$(discover_wifi_adapter)
if [[ -n "$wifi" ]]; then
    optional_modules=(${optional_modules[@]} 'wifi')
fi

cat > "$HOME/.config/polybar" <<EOF
[barcommon]
width = 100%
height = $polybar_bar_height

background = ${COLORSCHEME_POLYBAR_BG_COLOR}
foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}

border-size = 0

padding-left = 0
padding-right = 2

module-margin-left = 1
module-margin-right = 2

font-0 = $polybar_textfont
font-1 = $polybar_iconfont
font-2 = $polybar_wsiconfont

line-size = $polybar_ws_icon_underline_size
line-color = ${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}

monitor-strict = true
fixed-center = false

wm-restack = i3

tray-position =

cursor-click = pointer
cursor-scroll = ns-resize

[bar/left]
inherit = barcommon
monitor = $DISPLAYNAME_LEFT

modules-left = i3
modules-center =
modules-right = monitorname date


[bar/center]
inherit = barcommon

monitor = $DISPLAYNAME_CENTER

modules-left = i3 xwindow
modules-center =
modules-right = ${optional_modules[@]} updates syncthing music pulseaudio wlan monitorname date

[bar/right]
inherit = barcommon
monitor = $DISPLAYNAME_RIGHT

modules-left = i3
modules-center =
modules-right = monitorname date

[module/xwindow]
type = internal/xwindow
label = " %{F${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}}%{T2} %{T-}%{F-}%title:0:120:...% "
format-underline = ${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR}

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = false
wrapping-scroll = false

pin-workspaces = true

label-mode-padding = 1
label-mode-foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}
label-mode-background = ${COLORSCHEME_POLYBAR_BG_COLOR}

; focused = Active workspace on focused monitor
label-focused = %icon%
label-focused-background = ${COLORSCHEME_POLYBAR_BG_SELECTED_COLOR}
label-focused-foreground = ${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR}
label-focused-underline = ${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR}
label-focused-padding = \${self.label-mode-padding}

; unfocused = Inactive workspace on any monitor
label-unfocused = %icon%
label-unfocused-padding = \${self.label-mode-padding}

; visible = Active workspace on unfocused monitor
label-visible = %icon%
label-visible-background = ${COLORSCHEME_POLYBAR_BG_SELECTED_COLOR}
label-visible-foreground = ${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR}
label-visible-padding = \${self.label-mode-padding}

; urgent = Workspace with urgency hint set
label-urgent = %icon%
label-urgent-background = ${COLORSCHEME_POLYBAR_BG_URGENT_COLOR}
label-urgent-underline = ${COLORSCHEME_POLYBAR_BG_URGENT_UNDERLINE_COLOR}
label-urgent-padding = \${self.label-mode-padding}

; Separator in between workspaces
; label-separator = |

; icon configuration
fuzzy-match = true
ws-icon-0 = chat;%{T3}%{T-}
ws-icon-1 = slack;%{T3}%{T-}
ws-icon-2 = web;%{T3}%{T-}
ws-icon-3 = spotify;%{T3}%{T-}
ws-icon-4 = video;%{T3}%{T-}
ws-icon-5 = mail;%{T3}%{T-}
ws-icon-6 = game;%{T3}%{T-}
ws-icon-7 = term;%{T3}%{T-}
ws-icon-8 = doc;%{T3}%{T-}
ws-icon-9 = steam;%{T3}%{T-}
ws-icon-10 = work;%{T3}%{T-}
ws-icon-default = %{T3}%{T-}


[module/battery]
type = internal/battery

full-at = 98

battery = $battery
adapter = $power_adapter

time-format = %-lh %Mm

label-charging = %percentage%% (%time%)
format-charging = %{F${COLORSCHEME_GREEN}}%{F-} <label-charging>
format-charging-underline = ${COLORSCHEME_GREEN}

label-discharging = \${self.label-charging}
format-discharging = <ramp-capacity>%{F-} <label-discharging>
format-discharging-underline = ${COLORSCHEME_ORANGE}

ramp-capacity-0 = %{T3}%{F${COLORSCHEME_RED}}
ramp-capacity-1 = %{T3}%{F${COLORSCHEME_ORANGE}}
ramp-capacity-2 = %{T3}%{F${COLORSCHEME_YELLOW}}
ramp-capacity-3 = %{T3}%{F${COLORSCHEME_YELLOW}}
ramp-capacity-4 = %{T3}%{F${COLORSCHEME_GREEN}}


[module/music]
type = custom/script
exec = playerctl -p spotify metadata --format "{{ artist }} - {{ title }}"
exec-if = playerctl -p spotify status 2>&1 | grep -v -e 'No players found' -e 'Could not connect to players'
interval = 5
label = "%output% "
format-prefix = "  "
format-prefix-foreground = ${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}
format-prefix-font = 2
format-foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}
format-underline = ${COLORSCHEME_POLYBAR_MUSIC_UNDERLINE_COLOR}

[module/monitorname]
type = custom/script
exec = echo \$DISPLAYNAME
interval = 60
label = "%output% "
format-prefix = "  "
format-prefix-foreground = ${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}
format-prefix-font = 2
format-foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}
format-underline = ${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}

[module/syncthing]
type = custom/script
exec = \$DOTFILE_DIR/bin/i3/ststatus
interval = 5
label = " %{T2}%{A1:xdg-open http\://localhost\:8384:}%output%%{A}%{T-} "
label-underline = ${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}

[module/updates]
type = custom/script
exec = \$DOTFILE_DIR/bin/i3/updatestatus
interval = 3600
label-underline = ${COLORSCHEME_YELLOW}

[module/wifi]
type = internal/network
interface = $wifi
interval = 3.0

format-connected = <ramp-signal> <label-connected>
format-connected-underline = ${COLORSCHEME_GREEN}
label-connected = %essid% %signal%%

format-disconnected =
format-disconnected-underline = ${COLORSCHEME_RED}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-font = 2
ramp-signal-foreground = ${COLORSCHEME_POLYBAR_FG_SELECTED_COLOR}

[module/date]
type = custom/script
interval = 5
exec = \$DOTFILE_DIR/bin/i3/bardate

format-underline = ${COLORSCHEME_BLUE}

[module/pulseaudio]
type = internal/pulseaudio

label-volume = " %{F${COLORSCHEME_POLYBAR_FG_HIGHLIGHT_COLOR}}%{T2}%{F-}%{T-} %percentage:3%% "
label-volume-foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}
label-volume-underline = ${COLORSCHEME_POLYBAR_AUDIO_UNDERLINE_COLOR}

label-muted = " %{F${COLORSCHEME_RED}}%{T2}%{F-}%{T-} %percentage:3%% "
label-muted-foreground = ${COLORSCHEME_POLYBAR_FG_COLOR}
label-muted-underline = ${COLORSCHEME_POLYBAR_AUDIO_UNDERLINE_COLOR}

[settings]
screenchange-reload = true
EOF
