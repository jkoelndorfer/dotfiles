#!/bin/bash

konsole_profile="$HOME/.local/share/konsole/Shell.profile"
[[ -f "$konsole_profile" ]] || cp "kde/konsole/Shell.profile" "$konsole_profile"

hotkeys_file="$HOME/.config/khotkeysrc"
[[ -f "$hotkeys_file" ]] || cp "kde/khotkeysrc" "$hotkeys_file"

cp -f "kde/konsole/konsoleui.rc" "$HOME/.local/share/kxmlgui5/konsole/konsoleui.rc"
