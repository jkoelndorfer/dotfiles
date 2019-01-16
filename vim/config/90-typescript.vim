" Remove all existing filetype detection autocommands for *.ts files.
"
" By default, vim seems to think *.ts files should be XML (why?) and while
" the filetype is eventually set to typescript via the vim-typescript plugin,
" by that time Neomake has already registered xmllint as a maker for the file.
"
" The impact of that is that you get confusing XML errors in your quickfix
" list for typescript files.
"
" This fixes all that.
autocmd! filetypedetect BufNewFile *.ts
autocmd! filetypedetect BufReadPost *.ts

" vim-typescript does this for us, but because we blew away what it set up we
" have to reestablish it.
autocmd filetypedetect BufNewFile *.ts set ft=typescript
autocmd filetypedetect BufReadPost *.ts set ft=typescript
