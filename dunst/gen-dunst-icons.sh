#!/bin/bash

source "$DOTFILE_DIR/colors/solarized-dark"

function generate_icon() {
    local character="$1"
    local icon_path="$2"
    convert -size 28x32 \
        -background "$SOLARIZED_BASE02" \
        -fill "$SOLARIZED_BASE3" \
        -pointsize 28 \
        -font 'mononoki-Regular-Nerd-Font-Complete-Mono' \
        -gravity center \
        "label:$character" "$icon_path"
}

function process_icon_def() {
    # icon definitions will look something like this:
    #     new_icon = ~/.cache/dunsticons/slack.png # 
    local icon_def="$1"

    if ! [[ "$icon_def" =~ new_icon\ *=\ *([^#]+)\ #\ *([^ ]) ]]; then
        echo 'icon definition does not match expected regex:' >&2
        echo "$icon_def" >&2
        return 1
    fi
    local icon_name="${BASH_REMATCH[1]/#\~/$HOME}"
    local icon_path="$HOME/.cache/dunsticons/${icon_name}.png"
    local icon_char="${BASH_REMATCH[2]}"
    echo "Generating icon for '$icon_char' at $icon_path" >&2
    generate_icon "$icon_char" "$icon_path"
}

mkdir -p "$HOME/.cache/dunsticons"
grep -E 'new_icon\s*=\s*' "$DOTFILE_DIR/dunst/dunstrc" | while read l; do
    process_icon_def "$l"
done
