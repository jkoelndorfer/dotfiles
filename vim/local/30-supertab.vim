let g:SuperTabDefaultCompletionType = "context"

if exists('SuperTabChain')
    autocmd FileType *
        \ if &omnifunc != '' |
        \   call SuperTabChain(&omnifunc, "<c-x><c-p>") |
        \ endif
endif
