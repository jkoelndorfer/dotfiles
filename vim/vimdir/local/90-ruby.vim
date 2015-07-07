function! RubySettings()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
    setlocal colorcolumn=120
    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1
    let g:rubycomplete_rails = 1
    IndentGuidesEnable
endfunction

autocmd FileType ruby,eruby call RubySettings()
