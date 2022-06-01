function! LuaSettings()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
    setlocal colorcolumn=120

    execute 'EditorConfigReload'
endfunction

autocmd FileType lua call LuaSettings()
