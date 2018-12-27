#!/bin/bash

# htop rewrites its configuration file on every run, so we don't just
# configure a simple symlink. Instead, we deploy our settings when the
# dotfile installation script is run.

htop_rc="$HOME/.config/htop/htoprc"
mkdir -p "$(dirname "$htop_rc")"

# Colorscheme 6 is "broken gray" which works better with Solarized Dark.
# See https://github.com/hishamhm/htop/pull/144.
echo 'color_scheme=6' > "$htop_rc"
