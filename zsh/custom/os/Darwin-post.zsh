#!/usr/bin/env zsh

# Use GNU coreutils over BSD coreutils.
pathmunge_reorder '/usr/local/bin'
pathmunge_reorder '/usr/local/opt/coreutils/libexec/gnubin'

# Include Python 2.7 binaries in PATH.
pathmunge '/Library/Frameworks/Python.framework/Versions/2.7/bin'

nvim_path="$(which nvim 2>/dev/null)"
macvim_path='/Applications/MacVim.app/Contents/MacOS/Vim'

# OS X's builtin version of vim has a tendency to crash, so let's use nvim
# if available, else MacVim.
if [[ -n "$nvim_path" ]]; then
    alias vim="$nvim_path"
    alias vi="$nvim_path"
elif [[ -x "$macvim_path" ]]; then
    alias vim="$macvim_path"
    alias vi="$macvim_path"
fi

export EDITOR="$vim_path"
export VISUAL="$vim_path"
