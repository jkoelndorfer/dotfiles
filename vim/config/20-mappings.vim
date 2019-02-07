" Close buffers without losing the split
nmap <Leader>bd :bp \| bd #<CR>

" Maintain visual mode selection when adjusting indentation
vnoremap < <gv
vnoremap > >gv

nmap <Leader>p :set paste!<CR>
nmap <Leader>P :r! paste-from-clipboard<CR>

" This is a convenience mapping for Markdown to create an underline
" for the current line you're on. After hitting <Leader>h, press the
" character you want the underline to be composed of.
nmap <Leader>h V"zy"zpVr-Vr

" Open the quickfix list
" tag: error fix lint warning
nmap <Leader>e :lopen<CR>

" Easier way to break out of neovim's terminal
if has('nvim')
    tmap <C-Space><C-Space> <C-\><C-n>
endif

" Easier moving between splits
if has('nvim')
    nmap <BS> <C-w>h
endif
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

if has('nvim')
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
end

nmap ; :

" Ex mode? Who even uses that?
nnoremap Q <Nop>
nnoremap gQ <Nop>
