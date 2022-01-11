function! OpenFileBrowser()
    silent! 'CHADopen --always-focus --version-ctl'
    if v:errmsg != ""
        execute 'CHADopen --always-focus'
    endif
endfunction

nmap <F8> :call OpenFileBrowser()<CR>

let g:chadtree_settings = {
    \ 'options.follow': v:true,
    \ 'options.session': v:false,
    \ 'ignore.name_exact': ['.DS_Store', '.directory', 'thumbs.db', '.git', '.mypy_cache', '__pycache__', '.terraform', '.vagrant', '.venv'],
\ }
