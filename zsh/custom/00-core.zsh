#!/usr/bin/env zsh

DEFAULT_UMASK=0022
umask $DEFAULT_UMASK

setopt vi

export VIM_DIR="$REALHOME/.vim"
export VIM_BUNDLE_DIR="$REALHOME/.vim/bundle"
export VIM_RUNTIME_DIR="$DOTFILE_DIR/vim/vimdir/local"

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

# Configure a basic path. Should be fine for most use cases.
export PATH="/usr/bin:/usr/sbin:/bin:/sbin"
