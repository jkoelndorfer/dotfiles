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

let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#auto_close_doc = 0

let g:syntastic_python_checkers = ['python']
let g:pymode_rope = 0
