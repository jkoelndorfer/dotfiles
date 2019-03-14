#!/bin/bash

mononoki_mono_url='https://github.com/ryanoasis/nerd-fonts/raw/v2.0.0/patched-fonts/Mononoki/Regular/complete/mononoki-Regular%20Nerd%20Font%20Complete%20Mono.ttf'
mononoki_mono_file='mononoki-Regular Nerd Font Complete Mono.ttf'
fonts_dir="$HOME/.fonts"

mkdir -p "$fonts_dir"
cd "$fonts_dir"

if ! [[ -f "$mononoki_mono_file" ]]; then
    curl -L -o "$mononoki_mono_file" "$mononoki_mono_url"
fi
fc-cache -fv
