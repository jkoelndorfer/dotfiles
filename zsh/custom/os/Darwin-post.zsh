#!/usr/bin/env zsh

# Use GNU coreutils over BSD coreutils.
pathmunge_reorder '/usr/local/bin'
pathmunge_reorder '/usr/local/opt/coreutils/libexec/gnubin'

# Include Python 2.7 binaries in PATH.
pathmunge '/Library/Frameworks/Python.framework/Versions/2.7/bin'

vim_path='/Applications/MacVim.app/Contents/MacOS/Vim'
# OS X's builtin version of vim has a tendency to crash, so let's use MacVim
# instead.
alias vim="$vim_path"
alias vi="$vim_path"

export EDITOR="$vim_path"
export VISUAL="$vim_path"
