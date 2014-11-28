let g:airline#extensions#tabline#enabled = 1

" We need to set timeoutlen to a low value so that airline
" updates the current mode somewhat quickly.
set ttimeoutlen=50

" We don't want vim showing us the current mode, since airline
" does that for us.
set noshowmode

" Allow switching buffers via convenient airline shortcuts
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
