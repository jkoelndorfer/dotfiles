let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='med'

if !(expand('$TERM') == 'linux')
    silent! colorscheme solarized
endif
