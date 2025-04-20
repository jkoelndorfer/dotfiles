#!/bin/bash

source "${DOTFILE_DIR}/shell/lib/system.sh"

if ! type xdg-settings >/dev/null 2>&1; then
    exit 0
fi

if in-atomic-linux-context; then
    # `xdg-settings set` does not work properly on Fedora Kinoite
    # because qtpaths is not present. Skip setup in that case.
    printf 'cannot set default browser on atomic Linux host; skipping\n' >&2
    exit 0
fi

xdg-settings set default-web-browser firefox.desktop
