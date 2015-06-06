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

# Configure a basic path. Should be fine for most use cases.
export PATH="/usr/bin:/usr/sbin:/bin:/sbin"
