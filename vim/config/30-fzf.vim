nmap <C-p> :GFiles<return>
nmap <C-M-p> :Files<return>
nmap <C-b> :Buffers<return>
let g:fzf_layout = {'down': '25%'}
autocmd FileType fzf setlocal nonumber norelativenumber
autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
