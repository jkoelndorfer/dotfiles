let g:airline_theme='solarized'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Force set the branch symbol.
"
" For some reason the branch symbol is broken when I use Noto Mono.
let g:airline_symbols.branch = ''

" We need to set timeoutlen to a low value so that airline
" updates the current mode somewhat quickly.
set ttimeoutlen=50

" We don't want vim showing us the current mode, since airline
" does that for us.
set noshowmode
