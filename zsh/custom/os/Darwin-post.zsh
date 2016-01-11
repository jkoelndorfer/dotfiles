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
    vim_path="$nvim_path"
elif [[ -x "$macvim_path" ]]; then
    vim_path="$macvim_path"
else
    vim_path="$(which vim 2>/dev/null)"
fi

alias vim="$vim_path"
alias vi="$vim_path"
export EDITOR="$vim_path"
export VISUAL="$vim_path"
