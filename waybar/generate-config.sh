#!/bin/bash

source "$DOTFILE_DIR/theme/solarized-dark/colors"

function generate_style() {
    local display_profile=$1
    if [[ "$display_profile" == 'UHD' ]]; then
        local font_sz='22pt'
        local underline_sz='4px'
        local horizontal_spacing_sz='10px'
        local horizontal_spacing_sz_big='40px'
    elif [[ "$display_profile" == 'HD' ]]; then
        local font_sz='16pt'
        local underline_sz='2px'
        local horizontal_spacing_sz='5px'
        local horizontal_spacing_sz_big='20px'
    fi

    cat > "$HOME/.config/waybar/style-$display_profile.css" <<EOF
        * {
            border:        none;
            border-radius: 0;
            font-family:   mononoki Nerd Font Mono;
            font-size:     ${font_sz};
        }

        window#waybar {
            background-color: $SOLARIZED_BASE02;
            color:            $SOLARIZED_BASE1;
        }

        #window {
            margin-left: $horizontal_spacing_sz_big;

            padding: 0 $horizontal_spacing_sz;
            border-bottom-style: solid;
            border-bottom-width: $underline_sz;
            border-color: $SOLARIZED_BASE3;

            padding: 0 $horizontal_spacing_sz;
        }

        #waybar.empty #window {
            opacity: 0;
        }

        #workspaces button {
            padding: 0 $horizontal_spacing_sz;
            color:   $SOLARIZED_BASE1;
        }

        #workspaces button.focused {
            background-color: $SOLARIZED_BASE00;
            color: $SOLARIZED_BASE3;
        }

        .horizontal .modules-right widget label {
            margin: 0 $horizontal_spacing_sz;
            padding: 0 $horizontal_spacing_sz;
            border-bottom-style: solid;
            border-bottom-width: $underline_sz;
        }

        #pulseaudio {
            border-color: $SOLARIZED_CYAN;
        }

        #pulseaudio.muted, #pulseaudio.zeroed {
            color: $SOLARIZED_RED;
        }

        #custom-outputname {
            border-color: $SOLARIZED_BASE3;
        }

        #custom-date {
            border-color: $SOLARIZED_BLUE;
        }

        #custom-ststatus {
            border-color: $SOLARIZED_BASE3;
        }

        #custom-updates {
            border-color: $SOLARIZED_YELLOW;
        }
EOF
}

function generate_config() {
    local display_profile=$1
    local monitor_precedence=$2
    local output=$3

    if [[ "$display_profile" == 'UHD' ]]; then
        local bar_height='40'
    elif [[ "$display_profile" == 'HD' ]]; then
        local bar_height='20'
    fi
    read -r -d '' waybar_config_tmpl <<'EOF'
        {
            "layer":    "top",
            "position": "top",
            "height":   null,
            "output":   null,

            "modules-left": [
                "sway/workspaces",
                "sway/window"
            ],

            "modules-right": null,

            "sway/window": {
                "format": " {}"
            },

            "sway/workspaces": {
                "disable-scroll": true,
                "all-outputs": false,
                "format": "{icon}",
                "format-icons": {
                    "chat":    "",
                    "slack":   "",
                    "web":     "",
                    "video":   "",
                    "mail":    "",
                    "game":    "",
                    "term":    "",
                    "doc":     "",
                    "spotify": "",
                    "steam":   "",
                    "work":    "",
                    "default": ""
                }
            },

            "pulseaudio": {
                "format": "{icon} {volume}%",
                "format-icons": {
                    "default": ""
                },
                "states": {
                    "non-zeroed": 1,
                    "zeroed": 0
                },
                "format-muted": " {volume}%",
                "scroll-step": 5,
                "on-click": "pavucontrol"
            },

            "custom/date": {
                "exec": "$DOTFILE_DIR/bin/i3/bardate",
                "interval": 10,
                "tooltip": false
            },

            "custom/outputname": {
                "format": null,
                "interval": 60,
                "tooltip": false
            },

            "custom/ststatus": {
                "exec": "$DOTFILE_DIR/bin/i3/ststatus",
                "interval": 10,
                "on-click": "xdg-open http://localhost:8384",
                "tooltip": false
            },

            "custom/updates": {
                "exec": "$DOTFILE_DIR/bin/i3/updatestatus",
                "interval": 3600,
                "tooltip": false
            }
        }
EOF

    if [[ "$monitor_precedence" == 'PRIMARY' ]]; then
        local modules_right=('custom/updates' 'custom/ststatus' 'pulseaudio' 'custom/outputname' 'custom/date')
    else
        local modules_right=('custom/outputname' 'custom/date')
    fi
    echo -E "$waybar_config_tmpl" |
        jq \
            --raw-output \
            --arg output "$output" \
            --argjson bar_height "$bar_height" \
            '.height = $bar_height | .output = $output | .["custom/outputname"].format = " " + $output | .["modules-right"] = $ARGS.positional' \
            --args "${modules_right[@]}" \
            > "$HOME/.config/waybar/config-$display_profile-$monitor_precedence.json"
}

for dp in 'UHD' 'HD'; do
    for mp in 'PRIMARY' 'SECONDARY' 'TERTIARY'; do
        output_var="DISPLAYNAME_${mp}"
        output=${!output_var}
        if [[ -z "$output" ]]; then
            continue
        fi
        generate_config "$dp" "$mp" "$output"
    done
    generate_style "$dp"
done
