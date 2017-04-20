function! GoSettings()
    " Deoplete's popup menu interferes with Go autocompletion.
    " Additionally, deoplete-go did not work for me when I installed it.
    "
    " Let's just cut deoplete out when working on Go code.
    autocmd VimEnter * let b:deoplete_disable_auto_complete=1
endfunction

autocmd FileType go call GoSettings()
