function! RubySettings()
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=120
    setlocal nosmartindent
    setlocal foldmethod=indent
endfunction

autocmd FileType ruby,eruby call RubySettings()
autocmd FileType ruby,eruby IndentGuidesEnable
autocmd FileType ruby,eruby set colorcolumn=120
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1