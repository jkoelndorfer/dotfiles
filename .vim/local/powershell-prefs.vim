function! PowerShellSettings()
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
    setlocal smarttab
    setlocal expandtab
    setlocal textwidth=80
    setlocal nosmartindent
    setlocal foldmethod=indent
    setlocal ff=dos
endfunction
autocmd FileType ps1 call PowerShellSettings()
autocmd FileType ps1 IndentGuidesEnable
