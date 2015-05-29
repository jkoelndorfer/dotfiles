#!/usr/bin/env zsh

DEFAULT_UMASK=0022
umask $DEFAULT_UMASK

setopt vi

export VIM_DIR="$REALHOME/.vim"
export VIM_BUNDLE_DIR="$REALHOME/.vim/bundle"
export VIM_RUNTIME_DIR="$DOTFILE_DIR/vim/vimdir/local"
