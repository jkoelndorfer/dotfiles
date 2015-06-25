#!/usr/bin/env zsh

# Use GNU coreutils over BSD coreutils.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"

vim_path='/Applications/MacVim.app/Contents/MacOS/Vim'
# OS X's builtin version of vim has a tendency to crash, so let's use MacVim
# instead.
alias vim="$vim_path"
alias vi="$vim_path"

export EDITOR="$vim_path"
export VISUAL="$vim_path"
