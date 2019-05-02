function! TabComplete(menukey, whitespacekey, forcecomplete)
    let l:curcol = getcurpos()[2]
    if pumvisible()
        return a:menukey
    elseif ((getline('.')[:(l:curcol - 2)] =~ '^\s*$') || (l:curcol == 1)) && ! a:forcecomplete
        return a:whitespacekey
    else
        return "\<Plug>(ncm2_manual_trigger)"
    endif
endfunction

" Require tab to be pressed for code completion.
let g:ncm2#auto_popup = 0
autocmd BufEnter * call ncm2#enable_for_buffer()
imap <expr> <Tab>       TabComplete("\<C-n>", "\<Tab>", 0)
imap <expr> <S-Tab>     TabComplete("\<C-p>", "\<S-Tab>", 0)
imap <expr> <C-Space>   TabComplete("\<C-n>", "\<Space>", 1)
imap <expr> <C-S-Space> TabComplete("\<C-n>", "\<S-Space>", 1)
