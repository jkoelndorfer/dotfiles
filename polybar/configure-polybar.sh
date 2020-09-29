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

mkdir -p "$HOME/.config"
source "$DOTFILE_DIR/colors/solarized"

optional_modules=()

declare -A polybar_colors
polybar_colors[bright]=$SOLARIZED_BASE3
polybar_colors[background]=$SOLARIZED_BASE02
polybar_colors[foreground]=$SOLARIZED_BASE1
polybar_colors[selected_background]=$SOLARIZED_BASE00
polybar_colors[selected_foreground]=$SOLARIZED_BASE3
polybar_colors[urgent_background]=$SOLARIZED_BASE02
polybar_colors[urgent_underline]=$SOLARIZED_RED
polybar_colors[urgent_foreground]=$SOLARIZED_BASE3

if [[ "$DISPLAY_PROFILE" == 'UHD' ]]; then
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

cat > "$HOME/.config/polybar" <<EOF
[barcommon]
width = 100%
height = $polybar_bar_height

background = ${polybar_colors[background]}
foreground = ${polybar_colors[foreground]}

border-size = 0

padding-left = 0
padding-right = 2

module-margin-left = 1
module-margin-right = 2

font-0 = $polybar_textfont
font-1 = $polybar_iconfont
font-2 = $polybar_wsiconfont

line-size = $polybar_ws_icon_underline_size
line-color = ${polybar_colors[bright]}

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
label = " %{F${polybar_colors[bright]}}%{T2} %{T-}%{F-}%title:0:120:...% "
format-underline = ${polybar_colors[selected_foreground]}

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = false
wrapping-scroll = false

pin-workspaces = true

label-mode-padding = 1
label-mode-foreground = ${polybar_colors[foreground]}
label-mode-background = ${polybar_colors[background]}

; focused = Active workspace on focused monitor
label-focused = %icon%
label-focused-background = ${polybar_colors[selected_background]}
label-focused-foreground = ${polybar_colors[selected_foreground]}
label-focused-underline = ${polybar_colors[selected_foreground]}
label-focused-padding = \${self.label-mode-padding}

; unfocused = Inactive workspace on any monitor
label-unfocused = %icon%
label-unfocused-padding = \${self.label-mode-padding}

; visible = Active workspace on unfocused monitor
label-visible = %icon%
label-visible-background = ${polybar_colors[selected_background]}
label-visible-foreground = ${polybar_colors[selected_foreground]}
label-visible-padding = \${self.label-mode-padding}

; urgent = Workspace with urgency hint set
label-urgent = %icon%
label-urgent-background = ${polybar_colors[urgent_background]}
label-urgent-underline = ${polybar_colors[urgent_underline]}
label-urgent-padding = \${self.label-mode-padding}

; Separator in between workspaces
; label-separator = |

; icon configuration
fuzzy-match = true
ws-icon-0 = chat;%{T3}
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
format-charging = %{F${SOLARIZED_GREEN}}%{F-} <label-charging>
format-charging-underline = $SOLARIZED_GREEN

label-discharging = \${self.label-charging}
format-discharging = <ramp-capacity>%{F-} <label-discharging>
format-discharging-underline = $SOLARIZED_ORANGE

ramp-capacity-0 = %{T3}%{F${SOLARIZED_RED}}
ramp-capacity-1 = %{T3}%{F${SOLARIZED_ORANGE}}
ramp-capacity-2 = %{T3}%{F${SOLARIZED_YELLOW}}
ramp-capacity-3 = %{T3}%{F${SOLARIZED_YELLOW}}
ramp-capacity-4 = %{T3}%{F${SOLARIZED_GREEN}}


[module/music]
type = custom/script
exec = playerctl -p spotify metadata --format "{{ artist }} - {{ title }}"
exec-if = playerctl -p spotify status 2>&1 | grep -v -e 'No players found' -e 'Could not connect to players'
interval = 5
label = "%output% "
format-prefix = "  "
format-prefix-foreground = ${polybar_colors[bright]}
format-prefix-font = 2
format-foreground = ${polybar_colors[foreground]}
format-underline = $SOLARIZED_CYAN

[module/monitorname]
type = custom/script
exec = echo \$DISPLAYNAME
interval = 60
label = "%output% "
format-prefix = "  "
format-prefix-foreground = ${polybar_colors[bright]}
format-prefix-font = 2
format-foreground = ${polybar_colors[foreground]}
format-underline = ${polybar_colors[bright]}

[module/syncthing]
type = custom/script
exec = \$DOTFILE_DIR/bin/i3/ststatus
interval = 5
label = " %{T2}%{A1:xdg-open http\://localhost\:8384:}%output%%{A}%{T-} "
label-underline = ${polybar_colors[bright]}

[module/updates]
type = custom/script
exec = \$DOTFILE_DIR/bin/i3/updatestatus
interval = 3600
label-underline = $SOLARIZED_YELLOW

[module/wlan]
type = internal/network
interface = wlp8s0
interval = 3.0

format-connected = <ramp-signal> <label-connected>
format-connected-underline = $SOLARIZED_GREEN
label-connected = %essid% %signal%%

format-disconnected =
format-disconnected-underline = $SOLARIZED_RED

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-font = 2
ramp-signal-foreground = ${polybar_colors[selected_foreground]}

[module/date]
type = custom/script
interval = 5
exec = \$DOTFILE_DIR/bin/i3/polydate

format-underline = $SOLARIZED_BLUE

[module/pulseaudio]
type = internal/pulseaudio

label-volume = " %{F${polybar_colors[bright]}}%{T2}%{F-}%{T-} %percentage:3%% "
label-volume-foreground = ${polybar_colors[foreground]}
label-volume-underline = $SOLARIZED_CYAN

label-muted = %{F${SOLARIZED_RED}}%{T2}%{F-}%{T-} %percentage:3%%
label-muted-foreground = ${polybar_colors[foreground]}
label-muted-underline = $SOLARIZED_CYAN

[settings]
screenchange-reload = true
EOF
