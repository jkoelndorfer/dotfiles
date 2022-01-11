let g:coq_settings = {
    \ "completion.always": v:false,
    \ "keymap.recommended": v:false,
    \ "keymap.jump_to_mark": "<C-S-H>",
\ }

function! TabComplete(menukey, whitespacekey, forcecomplete)
    let l:curcol = getcurpos()[2]
    if pumvisible()
        return a:menukey
    elseif ((getline('.')[:(l:curcol - 2)] =~ '^\s*$') || (l:curcol == 1)) && ! a:forcecomplete
        return a:whitespacekey
    else
        return "\<C-X>\<C-U>"
    endif
endfunction

 imap <expr> <Tab>       TabComplete("\<C-n>", "\<Tab>", 0)
 imap <expr> <S-Tab>     TabComplete("\<C-p>", "\<S-Tab>", 0)
 imap <expr> <C-Space>   TabComplete("\<C-n>", "\<Space>", 1)
 imap <expr> <C-S-Space> TabComplete("\<C-n>", "\<S-Space>", 1)

 autocmd BufEnter * :COQnow -s
