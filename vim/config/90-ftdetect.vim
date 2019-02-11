" This filetype detection pattern was borrowed from:
" https://blog.afoolishmanifesto.com/posts/content-based-filetype-detection-in-vim/

function! DetectXml()
    if getline(1) =~ '<?xml'
        set filetype=xml
    endif
endfunction

augroup filetypedetect
    au BufRead,BufNewFile * call DetectXml()
augroup END
