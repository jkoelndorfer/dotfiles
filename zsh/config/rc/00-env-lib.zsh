# This file should contain ONLY functions required for basic zsh environment initialization.
#
# It is sourced directly by ~/.zshenv, which in turn is sourced by ~/.xprofile.
#
# xprofile seems to use its own shell implementation. Whatever it is, it's not zsh. I found
# that after adding confirm-cmd to my zsh configuration, lightdm would no longer start i3.
#
# It's probably best to make sure anything in this file is strictly POSIX shell compliant.

# Given a value, $s, that operates like PATH (e.g. a colon-separated
# list of items) adds an additional value to the list, $addn, if
# $addn is not already part of the list.
#
# If mode is 'after', $addn is added to the end.
function pathvarmunge() {
    local s=$1
    local addn=$2
    local mode=$3

    local addn_escaped=$(re_escape "$addn" '' 'extended')
    if ! echo "$s" | grep -E -q "(^|:)$addn_escaped($|:)"; then
        if [ "$mode" = "after" ] ; then
            echo "$s:$addn"
        else
            echo "$addn:$s"
        fi
    else
        echo "$s"
    fi
}

# Given a value, $s, that operates like PATH (e.g. a colon-separated
# list of items) adds an additional value to the list, $addn, if
# $addn is not already part of the list. If $addn is part of the list,
# it is reordered according to the behavior of pathmunge as though
# it were not in the list.
#
# If mode is 'after', $addn is added to the end.
function pathvarmunge_reorder() {
    local s=$1
    local addn=$2
    local mode=$3

    local addn_escaped=$(re_escape "$addn" '#' 'extended')
    local s_stripped="$(echo "$s" | sed -E -e "s#(^|:)$addn_escaped($|:)#:#g" | sed -E -e 's/(^:|:$)//')"
    pathvarmunge "$s_stripped" "$addn" "$mode"
}

function pathmunge() {
    export PATH=$(pathvarmunge "$PATH" "$@")
}

function pathmunge_reorder() {
    export PATH=$(pathvarmunge_reorder "$PATH" "$@")
}

# This regex escape function is borrowed from:
# https://backreference.org/2009/12/09/using-shell-variables-in-sed/
function re_escape() {
    local s=$1
    local sed_separator=$2
    local re_mode=$3

    local sed_escape_re
    if [[ "$re_mode" == 'basic' ]]; then
        sed_escape_re='s/[[\.*^$'$sed_separator']/\\&/g'
    elif [[ "$re_mode" == 'extended' ]]; then
        sed_escape_re='s/[[\.*^$(){}?+|'"$sed_separator"']/\\&/g'
    fi
    printf "%s\n" "$s" | sed -e "$sed_escape_re"
}
