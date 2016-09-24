#!/usr/bin/env zsh

DEFAULT_UMASK=0022
umask $DEFAULT_UMASK

setopt vi

# Determine operating system.
#
# We're putting this in the environment because it might be useful to
# settings for other programs - and we may need to play with the value
# of uname to make it not stupid.
export OS="$(uname)"

# Determine hostname.
#
# Dunno why OS X has to be so special...
for cmd in 'hostname -s' 'uname -n' 'scutil --get LocalHostName'; do
    export HOSTNAME="$(eval "$cmd 2>/dev/null")"
    if [[ -n "$HOSTNAME" ]]; then
        break
    fi
done

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
    PATH="$(echo "$PATH" | sed -E -e "s#(^|:)$1($|:)#:#" | sed -E -e 's/(^:|:$)//')"
    pathmunge "$@"
}

# Configure a basic path if there is not one. Should be fine for most use cases.
[[ -z "$PATH" ]] && PATH="/usr/bin:/usr/sbin:/bin:/sbin"
