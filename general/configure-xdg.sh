#!/bin/bash

if ! type xdg-settings >/dev/null 2>&1; then
    exit 0
fi

xdg-settings set default-web-browser firefox.desktop
