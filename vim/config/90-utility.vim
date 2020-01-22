function! FormatJson(line1, line2)
    execute a:line1 . ',' . a:line2 . '!python -m json.tool'
endfunction

" Open a file adjacent (i.e. in the same directory as) the current file.
function! EAdjacent(filename)
    execute 'e ' . expand("%:p:h") . '/' . a:filename
endfunction

command! -range=% FormatJson call FormatJson(<line1>, <line2>)
command! -nargs=1 Eadj call EAdjacent(<q-args>)
