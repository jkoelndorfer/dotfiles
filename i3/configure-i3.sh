#!/bin/zsh

if [[ "$(uname)" != 'Linux' ]]; then
    exit 0
fi

script_dir=$(dirname "$0")
cd "$script_dir"

setopt null_glob

function generate_config() {
    # wm should be one of i3 or sway.
    #
    # Some configuration elements will be i3-specific or sway-specific.
    local wm=$1
    local config_path=$2

    mkdir -p "$(dirname "$config_path")"

    {
        for f in config.d/* config.d/host/"$(hostname -s)"/*; do
            if [[ "$f" == 'config.d/host' ]]; then
                continue
            elif [[ -x "$f" ]]; then
                "./$f" "$wm"
            elif [[ -f "$f" ]]; then
                cat "$f"
            fi
            echo
        done
    } > "$config_path"
}

for wm in i3 sway; do
    generate_config "$wm" "$HOME/.config/$wm/config"
done
