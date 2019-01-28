function! FormatJson(line1, line2)
    execute a:line1 . ',' . a:line2 . '!python -m json.tool'
endfunction

command! -range=% FormatJson call FormatJson(<line1>, <line2>)
