let g:airline_theme='solarized'
let g:airline_solarized_dark_inactive_border = '1'

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

" Configure symbols so they're compatible with Nerd Fonts.
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.whitespace = ''
let g:airline_symbols.maxlinenr = ' ln'

" Remove the nontexists symbol.
"
" This symbol is used to indicate a file that is not tracked in the current
" version control repository. Unfortunately, it only works after you actually
" save the file so it's less useful. Also, it's kinda ugly.
let g:airline_symbols.notexists = ''

let g:airline_mode_map = {
  \ '__' : '-',
  \ 'c'  : 'C',
  \ 'i'  : 'I',
  \ 'ic' : 'I',
  \ 'ix' : 'I',
  \ 'n'  : 'N',
  \ 'ni' : 'N',
  \ 'no' : 'N',
  \ 'R'  : 'R',
  \ 'Rv' : 'R',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ 't'  : 'T',
  \ 'v'  : 'V',
  \ 'V'  : 'V',
  \ '' : 'V',
  \ }

" We need to set timeoutlen to a low value so that airline
" updates the current mode somewhat quickly.
set ttimeoutlen=50

" We don't want vim showing us the current mode, since airline
" does that for us.
set noshowmode
