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

    " Use the configuration above for Python but defer to a
    " .editorconfig if one exists.
    execute 'EditorConfigReload'
endfunction
autocmd FileType python call PythonSettings()

" See:
" https://github.com/ncm2/ncm2/pull/178
" https://github.com/ray-x/lsp_signature.nvim
lua << EOF
local ncm2 = require('ncm2')
local lsp_signature = require('lsp_signature')
require('lspconfig').jedi_language_server.setup({
    cmd = {vim.env.DOTFILE_DIR .. '/dev/language-servers/python'},
    on_init = function(client, bufnr)
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = vim.g['lsp_border']})
        lsp_signature.on_attach({
            hint_enable = false,
            hi_parameter = "WildMenu",
        })
        ncm2.register_lsp_source(client, bufnr)
    end
})
EOF

let g:neomake_open_list = 0
let g:neomake_python_enabled_makers = ["flake8", "mypy"]

if executable('flake8')
    let s:flake8_path = 'flake8'
else
    let s:flake8_path = expand("$PYTHON_DEV_VENV") . "/bin/flake8"
endif
let g:neomake_python_flake8_maker = {
    \ 'exe': s:flake8_path,
    \ 'make_info': "flake8",
\ }

if executable('mypy')
    let s:mypy_path = 'mypy'
else
    let s:mypy_path = expand("$PYTHON_DEV_VENV") . "/bin/mypy"
endif
let g:neomake_python_mypy_maker = {
    \ 'exe': s:mypy_path,
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

let g:black_linelength = 120

augroup PythonBlack
    autocmd!
    autocmd BufWritePre *.py :Black
augroup END

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
