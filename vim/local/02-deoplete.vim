if has('nvim')
    let g:deoplete#enable_at_startup = 1

    inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "<S-Tab>"
    inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ deoplete#mappings#manual_complete()
        function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}

    " Make vim-jedi completions show up first in deoplete's
    " completion list.
    call deoplete#custom#set('jedi', 'rank', 9999)

    call deoplete#custom#set('jedi', 'matchers', ['matcher_full_fuzzy'])

    " Show function signatures in the function preview window
    let g:deoplete#sources#jedi#show_docstring = 1
endif
