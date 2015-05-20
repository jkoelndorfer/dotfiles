let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" We need to set timeoutlen to a low value so that airline
" updates the current mode somewhat quickly.
set ttimeoutlen=50

" We don't want vim showing us the current mode, since airline
" does that for us.
set noshowmode
