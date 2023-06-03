#!/bin/zsh

source "$DOTFILE_DIR/zsh/lib/misc.zsh"

function font_variant_name() {
    local font_variant=$1

    sed -r -e 's/-//g' <<<"$font_variant"
}

function font_path() {
    local font_name=$1
    local font_variant=$2

    printf 'patched-fonts/%s/%s' "$font_name" "$font_variant"
}

function font_file_name() {
    local font_name=$1
    local font_variant=$2

    printf '%sNerdFontMono-%s.ttf' "$font_name" "$(font_variant_name "$font_variant")"
}

font_name='Mononoki'
font_rev='HEAD'
variants=(Regular Italic Bold Bold-Italic)

fonts_dir="$HOME/.fonts"
mkdir -p "$fonts_dir"
cd "$fonts_dir"

fonts_downloaded=0
for font_variant in "${variants[@]}"; do
    file_name=$(font_file_name "$font_name" "$font_variant")
    font_url="https://github.com/ryanoasis/nerd-fonts/raw/${font_rev}/$(font_path "$font_name" "$font_variant")/$(urlencode "$file_name")"

    if ! [[ -f "$file_name" ]]; then
        printf 'downloading font: %s\n' "$font_url" >&2
        fonts_downloaded=1
        curl -L -o "$file_name" "$font_url"
    else
        printf 'font already downloaded; skipping: %s\n' "$font_url" >&2
    fi
done
if [[ "$fonts_downloaded" == '1' ]]; then
    fc-cache -fv
fi
