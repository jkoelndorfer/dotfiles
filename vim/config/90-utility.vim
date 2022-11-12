function! FormatJson(line1, line2)
    execute a:line1 . ',' . a:line2 . '!python -m json.tool'
endfunction

" Open a file adjacent (i.e. in the same directory as) the current file.
function! EAdjacent(filename)
    execute 'e ' . expand("%:p:h") . '/' . a:filename
endfunction

function CurrentBufferPath()
    echo @%
endfunction

function RestartNeovim()
    call writefile(['1'], expand('$NEOVIM_RESTART_FLAG'))
    execute 'qa'
endfunction

function FQuit()
    call writefile(['0'], expand('$NEOVIM_RESTART_FLAG'))
    execute 'qa'
endfunction

command! -range=% FormatJson call FormatJson(<line1>, <line2>)
command! -nargs=1 Eadj call EAdjacent(<q-args>)
command! CurrentBufferPath call CurrentBufferPath()
command! RestartNeovim call RestartNeovim()
command! FQuit call FQuit()
