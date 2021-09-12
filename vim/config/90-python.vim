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

    " Use the configuration above for Python but defer to a
    " .editorconfig if one exists.
    execute 'EditorConfigReload'
endfunction
autocmd FileType python call PythonSettings()

let s:pyls_path = expand("$DOTFILE_DIR") . "/dev/language-servers/python"
if executable(s:pyls_path)
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->[s:pyls_path]},
        \ 'allowlist': ['python'],
    \ })
endif

let g:neomake_open_list = 0
let g:neomake_python_enabled_makers = ["flake8", "mypy"]

let g:neomake_python_flake8_maker = {
    \ 'exe': expand("$PYTHON_DEV_VENV") . "/bin/flake8",
    \ 'make_info': "flake8",
\ }

let g:neomake_python_mypy_maker = {
    \ 'exe': expand("$PYTHON_DEV_VENV") . "/bin/mypy",
    \ 'args': ['--ignore-missing-imports', '--follow-imports', 'silent'],
    \ 'make_info': "mypy",
\ }

let g:pymode_doc_bind = "<leader>PK"
let g:pymode_run_bind = "<leader>Pr"
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_autoimport = 0
let g:pymode_syntax = 1
let g:pymode_options_max_line_length = 120

function! SlimuxPre_python(target_pane)
    " This assumes ipython running with vi-keybinds.
    call system("tmux send-keys -t " . a:target_pane . " C-c")
    call system("tmux send-keys -t " . a:target_pane . " Escape")
    call system("tmux send-keys -t " . a:target_pane . " i")
    call system("tmux send-keys -t " . a:target_pane . " '%cpaste\n'")
endfunction

function! SlimuxPost_python(target_pane)
    call system("tmux send-keys -t " . a:target_pane . " '\n--\n'")
endfunction
