#!/usr/bin/env zsh

# Use GNU coreutils over BSD coreutils.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"

# OS X's builtin version of vim has a tendency to crash, so let's use MacVim
# instead.
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias vi='/Applications/MacVim.app/Contents/MacOS/Vim'
