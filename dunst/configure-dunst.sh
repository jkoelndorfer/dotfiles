#!/bin/bash

source "$DOTFILE_DIR/colors/solarized"

dunst_config_dir="$HOME/.config/dunst"

xrdb_q=$(xrdb -query)
polybar_barheight=$(echo "$xrdb_q" | awk '$1 == "polybar.barheight:" { print $2 }')
gaps_outer=$(echo "$xrdb_q" | awk '$1 == "i3wm.gaps_outer:" { print $2 }')
window_border=$(echo "$xrdb_q" | awk '$1 == "i3wm.default_border:" { print $2 }')
if [[ "$DISPLAY_PROFILE" == "HD" ]]; then
    x=$(( gaps_outer + window_border ))
    y=$(( polybar_barheight + gaps_outer + window_border ))
    dunst_frame_width=2
    geometry="300x5-$x+$y"
elif [[ "$DISPLAY_PROFILE" == "UHD" ]]; then
    # In order to line up correctly, the dunst window needs to be positioned
    # differently on a 4k display. I believe it has to do with some apps scaling
    # with 4k and others not.
    x=$(( (gaps_outer * 2) + (window_border * 2) + 1 ))
    y=$(( polybar_barheight + (gaps_outer * 2) + (window_border * 2) + 1 ))
    dunst_frame_width=4
    geometry="600x5-$x+$y"
fi

read -r -d '' dunst_config <<EOF
[global]
    follow = keyboard

    # The geometry of the window:
    #   [{width}]x{height}[+/-{x}+/-{y}]
    # The geometry of the message window.
    # The height is measured in number of notifications everything else
    # in pixels.  If the width is omitted but the height is given
    # ("-geometry x2"), the message window expands over the whole screen
    # (dmenu-like).  If width is 0, the window expands to the longest
    # message displayed.  A positive x is measured from the left, a
    # negative from the right side of the screen.  Y is measured from
    # the top and down respectively.
    # The width can be negative.  In this case the actual width is the
    # screen width minus the width defined in within the geometry option.
    geometry = "$geometry"

    indicate_hidden = yes
    shrink = no
    transparency = 0
    notification_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    frame_width = $dunst_frame_width
    show_indicators = false

    frame_color = "$SOLARIZED_BASE01"
    separator_color = frame
    sort = no
    idle_threshold = 0
    font = mononoki Nerd Font Mono 10
    line_height = 2
    markup = full

    # The format of the message.  Possible variables are:
    #   %a  appname
    #   %s  summary
    #   %b  body
    #   %i  iconname (including its path)
    #   %I  iconname (without its path)
    #   %p  progress value if set ([  0%] to [100%]) or nothing
    #   %n  progress value if set without any extra characters
    #   %%  Literal %
    # Markup is allowed
    format = "<b>%s</b>\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = end
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes

    # Align icons left/right/off
    icon_position = left

    sticky_history = yes
    history_length = 20

    dmenu = /usr/bin/rofi -p dunst:
    browser = /usr/bin/xdg-open

    # Always run rule-defined scripts, even if the notification is suppressed
    always_run_script = true

    title = Dunst
    class = Dunst
    startup_notification = false
    force_xinerama = false

[shortcuts]
    # Shortcuts are specified as [modifier+][modifier+]...key
    # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
    # "mod3" and "mod4" (windows-key).
    # Xev might be helpful to find names for keys.

    # Close notification.
    close = ctrl+space

    # Close all notifications.
    close_all = ctrl+shift+space

    # Redisplay last message(s).
    # On the US keyboard layout "grave" is normally above TAB and left
    # of "1". Make sure this key actually exists on your keyboard layout,
    # e.g. check output of 'xmodmap -pke'
    history = ctrl+grave

    # Context menu.
    context = ctrl+shift+period

[urgency_low]
    background = "$SOLARIZED_BASE02"
    foreground = "$SOLARIZED_BASE1"
    timeout = 5

[urgency_normal]
    background = "$SOLARIZED_BASE02"
    foreground = "$SOLARIZED_BASE1"
    timeout = 5

[urgency_critical]
    background = "$SOLARIZED_BASE02"
    foreground = "$SOLARIZED_BASE1"
    frame_color = "$SOLARIZED_RED"
    timeout = 0

# NOTE: We use some shell script magic to autogenerate these
# icons. Formatting is a bit precise. See gen-dunst-icons.sh
# in this directory.
[slack]
    appname = Slack
    new_icon = slack # 

[discord]
    appname = Discord
    new_icon = discord # ﭮ
EOF

echo "$dunst_config" > "$dunst_config_dir/dunstrc"
