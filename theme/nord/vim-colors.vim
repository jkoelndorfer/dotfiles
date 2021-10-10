if !(expand('$TERM') == 'linux')
    silent! colorscheme nord

    " Make vim selection match tmux
    hi Visual ctermbg=3 ctermfg=0
endif
