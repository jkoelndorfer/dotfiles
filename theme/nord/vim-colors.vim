if !(expand('$TERM') == 'linux')
    silent! colorscheme nord

    " Make vim selection match tmux
    hi Visual ctermbg=3 ctermfg=0
endif

" Ordinarily I like cursorline, but with the nord colorscheme
" the contrast is just too low when the highlighted line is a comment.
set nocursorline
