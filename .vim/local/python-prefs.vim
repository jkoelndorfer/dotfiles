function! PythonSettings()
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=80
    setlocal nosmartindent
    setlocal foldmethod=indent
endfunction
autocmd FileType python call PythonSettings()
autocmd FileType python IndentGuidesEnable

let g:syntastic_python_checkers = ['python']
let g:pymode_rope = 0
