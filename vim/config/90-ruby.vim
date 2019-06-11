function! RubyCommonSettings()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
    setlocal colorcolumn=120
    IndentGuidesEnable

    execute 'EditorConfigReload'
endfunction

function! YamlSettings()
    call RubyCommonSettings()
endfunction

function! RubySettings()
    call RubyCommonSettings()
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1
endfunction

autocmd FileType ruby,eruby call RubySettings()
autocmd FileType yaml call YamlSettings()
