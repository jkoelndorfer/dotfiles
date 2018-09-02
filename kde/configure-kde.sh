#!/bin/bash

cd "$(dirname "$0")"

konsole_profile="$HOME/.local/share/konsole/Shell.profile"
mkdir -p "$(dirname "$konsole_profile")"
[[ -f "$konsole_profile" ]] || cp "konsole/Shell.profile" "$konsole_profile"

hotkeys_file="$HOME/.config/khotkeysrc"
mkdir -p "$(dirname "$hotkeys_file")"
[[ -f "$hotkeys_file" ]] || cp "khotkeysrc" "$hotkeys_file"

consoleui_rc_file="$HOME/.local/share/kxmlgui5/konsole/konsoleui.rc"
mkdir -p "$(dirname "$consoleui_rc_file")"
cp -f "konsole/konsoleui.rc" "$consoleui_rc_file"
