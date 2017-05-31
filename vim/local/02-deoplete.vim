if has('nvim')
    let g:deoplete#enable_at_startup = 1

    " Make vim-jedi completions show up first in deoplete's
    " completion list.
    call deoplete#custom#set('jedi', 'rank', 9999)
endif
