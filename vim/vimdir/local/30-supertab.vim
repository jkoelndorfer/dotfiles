let g:SuperTabDefaultCompletionType = "context"

autocmd FileType *
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-x><c-p>") |
    \ endif
