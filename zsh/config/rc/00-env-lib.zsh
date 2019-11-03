# This file should contain ONLY functions required for basic zsh environment initialization.
#
# It is sourced directly by ~/.zshenv, which in turn is sourced by ~/.xprofile.
#
# xprofile seems to use its own shell implementation. Whatever it is, it's not zsh. I found
# that after adding confirm-cmd to my zsh configuration, lightdm would no longer start i3.
#
# It's probably best to make sure anything in this file is strictly POSIX shell compliant.
function pathmunge() {
    if ! echo $PATH | grep -E -q "(^|:)$1($|:)"; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

function pathmunge_reorder() {
    PATH="$(echo "$PATH" | sed -E -e "s#(^|:)$1($|:)#:#g" | sed -E -e 's/(^:|:$)//')"
    pathmunge "$@"
}
