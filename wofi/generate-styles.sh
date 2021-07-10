#!/bin/bash

script_dir=$(dirname "$0")
cd "$script_dir"
source "$DOTFILE_DIR/theme/solarized-dark/colors"

wofi_config_dir="$HOME/.config/wofi"
mkdir -p "$wofi_config_dir"

function generate_wofi_style() {
    local display_profile=$1
    if [[ "$display_profile" == 'UHD' ]]; then
        local font_sz='20pt'
        local input_font_sz='24pt'
        local margin_sz='6px'
        local big_margin_sz='12px'
        local border_sz='4px'
    elif [[ "$display_profile" == 'HD' ]]; then
        local font_sz='12pt'
        local input_font_sz='16pt'
        local margin_sz='3px'
        local big_margin_sz='6px'
        local border_sz='2px'
    fi
    read -r -d '' css_theme <<EOF
    * {
        font: ${font_sz} mononoki Nerd Font Mono;
    }

    #inner-box {
        margin: 12px;
    }

    #outer-box {
        background:   $SOLARIZED_BASE03;

        border-style: solid;
        border-color: $SOLARIZED_BASE1;
        border-width: $border_sz;
    }

    #input {
        font:             ${input_font_sz} mononoki Nerd Font Mono;
        border:           none;
        background-color: $SOLARIZED_BASE01;
        color:            $SOLARIZED_BASE3;
        margin:           $big_margin_sz;
    }

    #entry:nth-child(even) {
        background-color: $SOLARIZED_BASE03;
    }

    #entry:nth-child(odd) {
        background-color: $SOLARIZED_BASE02;
    }

    #entry:selected {
        background-color: $SOLARIZED_BASE1;
        color:            $SOLARIZED_BASE3;
    }

    #text {
        margin: $margin_sz;
        border: none;
    }

    #entry {
        color: $SOLARIZED_BASE1;
    }

    #scroll {
        margin: 0px;
        border: none;
    }
EOF
    echo "$css_theme" > "$wofi_config_dir/style-${display_profile}.css"
}

generate_wofi_style 'HD'
generate_wofi_style 'UHD'
