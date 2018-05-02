nmap <C-p> :GFiles<return>
nmap <C-M-p> :Files<return>
nmap <C-b> :Buffers<return>

function! s:fzf_statusline()
    highlight fzf1 ctermbg=0
    highlight fzf2 ctermbg=0
    highlight fzf3 ctermbg=0
    setlocal statusline=%#fzf1#\ fzf>
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()
