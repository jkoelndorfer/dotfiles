nmap <F8> :NERDTreeTabsToggle<CR>
nmap <F9> :TagbarToggle<CR>

" Slimux configuration
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
nmap <Leader>l :SlimuxREPLSendBuffer<CR>

" Quick search a list of open buffers with CtrlP
nmap <C-b> :CtrlPBuffer<CR>

" Easier way to break out of neovim's terminal
if has('nvim')
    " C-@ is equivalent to C-Space, but it actually works
    " (C-Space doesn't for some reason)
    tnoremap <C-@><C-@> <C-\><C-n>
endif

" Easier moving between splits
if has('nvim')
    nmap <BS> <C-w>h
endif
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

nmap ; :

" Ex mode? Who even uses that?
nnoremap Q <Nop>
nnoremap gQ <Nop>
