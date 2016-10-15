#!/usr/bin/env zsh

# Use GNU coreutils over BSD coreutils.
pathmunge_reorder '/usr/local/bin'
pathmunge_reorder '/usr/local/opt/coreutils/libexec/gnubin'

# Include Python 2.7 binaries in PATH.
pathmunge '/Library/Frameworks/Python.framework/Versions/2.7/bin'

nvim_path="$(which nvim 2>/dev/null)"
macvim_path='/Applications/MacVim.app/Contents/MacOS/Vim'
