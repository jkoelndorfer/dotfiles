if has('nvim')
    let g:deoplete#enable_at_startup = 1

    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()

    " Make vim-jedi completions show up first in deoplete's
    " completion list.
    call deoplete#custom#set('jedi', 'rank', 9999)

    call deoplete#custom#set('jedi', 'matchers', ['matcher_full_fuzzy'])

    " Show function signatures in the function preview window
    let g:deoplete#sources#jedi#show_docstring = 1
endif
