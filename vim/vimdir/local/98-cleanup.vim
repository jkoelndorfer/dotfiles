" Clean up dumb settings that may have been set by a bad
" global vimrc.
"
" I'm looking at you, OpenWRT.

" This fixes any terminal settings that may have been screwed with.
" We're gonna trust that our termcap is right.
if !has('nvim')
    set term=$TERM
endif
