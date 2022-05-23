#!/bin/zsh -l
#
if [[ "$(uname)" != 'Linux' ]]; then
    exit 0
fi

source "$DOTFILE_DIR/theme/$DESKTOP_THEME/colors"

display_profile=$("$DOTFILE_DIR/bin/gui/display-profile")

if [[ "$display_profile" == "UHD" ]]; then
    icon_size='96x96'
    pointsize=96
else
    icon_size='48x48'
    pointsize=56
fi

function generate_icon() {
    local character="$1"
    local icon_path="$2"
    convert -size "$icon_size" \
        -background "$COLORSCHEME_DUNST_BG_COLOR" \
        -fill "$COLORSCHEME_PRIMARY_FG_COLOR" \
        -pointsize "$pointsize" \
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
    local icon_name="${match[1]/#\~/$HOME}"
    local icon_path="$HOME/.cache/dunsticons/${icon_name}.png"
    local icon_char="${match[2]}"
    echo "Generating icon for '$icon_char' at $icon_path" >&2
    generate_icon "$icon_char" "$icon_path"
}

mkdir -p "$HOME/.cache/dunsticons"
grep -E 'new_icon\s*=\s*' "$HOME/.config/dunst/dunstrc" | while read l; do
    process_icon_def "$l"
done
