function! TabComplete(menukey, whitespacekey)
    if pumvisible()
        return a:menukey
    elseif getline('.') =~ '^\s*$'
        return a:whitespacekey
    else
        return "\<Plug>(ncm2_manual_trigger)"
    endif
endfunction

autocmd BufEnter * call ncm2#enable_for_buffer()
au TextChangedI * call ncm2#auto_trigger()
imap <expr> <Tab>   TabComplete("\<C-n>", "\<Tab>")
imap <expr> <S-Tab> TabComplete("\<C-p>", "\<S-Tab>")
