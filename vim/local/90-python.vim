function! PythonSettings()
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal smarttab
    setlocal expandtab
    setlocal colorcolumn=120
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
    autocmd VimEnter * IndentGuidesEnable
    autocmd VimEnter * NERDTree
    " NERDTree grabs focus when it opens, so switch back to the file
    " we're editing.
    autocmd VimEnter * execute "normal \<C-W>l"
    autocmd VimEnter * TagbarOpen
    autocmd BufWritePost *.py call Flake8()
endfunction
autocmd FileType python call PythonSettings()

let g:jedi#show_call_signatures = 1
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 1
let g:jedi#auto_close_doc = 1

let g:syntastic_python_checkers = ['python']
let g:pymode_folding = 1
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_syntax = 1
let g:pymode_options_max_line_length = 120

let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

function SlimuxPre_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '%cpaste\n'")
endfunction

function SlimuxPost_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '\n--\n'")
endfunction
