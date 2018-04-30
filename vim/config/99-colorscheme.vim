let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='med'

if !(expand('$TERM') == 'linux')
    silent! colorscheme solarized
    " Make visual-mode highlighting match tmux (and stand out more)
    hi Visual cterm=reverse ctermfg=3 guifg=Black guibg=Yellow
endif
