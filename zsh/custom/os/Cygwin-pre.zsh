#!/usr/bin/env zsh

function mintty_title {
    echo -ne "\033]2;"$1"\007"
}

pathmunge '/cygdrive/c/Windows/System32' 'after'
# Set solarized colors for mintty
echo -ne "\e]10;#839496\a" # foreground
echo -ne "\e]11;#002B36\a" # background
echo -ne "\e]12;#FFFFFF\a" # cursor
echo -ne "\e]P0073642\a"
echo -ne "\e]P8002b36\a"
echo -ne "\e]P1dc322f\a"
echo -ne "\e]P9cb4b16\a"
echo -ne "\e]P2859900\a"
echo -ne "\e]PA586e75\a"
echo -ne "\e]P3b58900\a"
echo -ne "\e]PB657b83\a"
echo -ne "\e]P4268bd2\a"
echo -ne "\e]PC839496\a"
echo -ne "\e]P5d33682\a"
echo -ne "\e]PD6c71c4\a"
echo -ne "\e]P62aa198\a"
echo -ne "\e]PE93a1a1\a"
echo -ne "\e]P7eee8d5\a"
echo -ne "\e]PFfdf6e3\a"
