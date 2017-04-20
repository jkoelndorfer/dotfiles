#!/bin/bash

konsole_profile="$HOME/.local/share/konsole/Shell.profile"
[[ -f "$konsole_profile" ]] || cp "kde/konsole/Shell.profile" "$konsole_profile"
