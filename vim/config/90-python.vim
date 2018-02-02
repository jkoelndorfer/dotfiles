" Inserts the current directory into vim's Python instance's path.
" This is needed for completion on our current project to work correctly.
let g:py_path_fix_script = 'from os import getcwd; import sys; sys.path.insert(0, getcwd())'

if has('python')
    execute 'py ' . g:py_path_fix_script
endif
if has('python3')
    execute 'py3 ' . g:py_path_fix_script
endif

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
    autocmd BufWritePost *.py Neomake
    setlocal omnifunc=syntaxcomplete#Complete
endfunction
autocmd FileType python call PythonSettings()

" deoplete-jedi handles this
let g:jedi#completions_enabled = 0

let g:deoplete#sources#jedi#extra_path = ["."]

let g:neomake_open_list = 2
let g:neomake_python_enabled_makers = ["flake8"]

let g:pymode_doc_bind = "<leader>PK"
let g:pymode_run_bind = "<leader>Pr"
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_syntax = 1
let g:pymode_options_max_line_length = 120

let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

function SlimuxPre_python(target_pane)
    " This assumes ipython running with vi-keybinds.
    call system("tmux send-keys -t " . a:target_pane . " C-c")
    call system("tmux send-keys -t " . a:target_pane . " Escape")
    call system("tmux send-keys -t " . a:target_pane . " i")
    call system("tmux send-keys -t " . a:target_pane . " '%cpaste\n'")
endfunction

function SlimuxPost_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '\n--\n'")
endfunction
