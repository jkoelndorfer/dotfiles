function! PythonSettings()
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
endfunction
autocmd FileType python call PythonSettings()
autocmd FileType python IndentGuidesEnable
autocmd FileType python set colorcolumn=120

let g:jedi#show_call_signatures = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#auto_close_doc = 0

let g:syntastic_python_checkers = ['python']
let g:pymode_rope = 0
let g:pymode_options_max_line_length = 120

function SlimuxPre_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '%cpaste\n'")
endfunction

function SlimuxPost_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '\n--\n'")
endfunction
