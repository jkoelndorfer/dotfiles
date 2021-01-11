function! TmuxPaste()
    r!tmux save-buffer /dev/stdout
endfunction

nmap <Leader>tp :call TmuxPaste()<cr>
nmap <C-h> :TmuxNavigateLeft<cr>
nmap <C-j> :TmuxNavigateDown<cr>
nmap <C-k> :TmuxNavigateUp<cr>
nmap <C-l> :TmuxNavigateRight<cr>
