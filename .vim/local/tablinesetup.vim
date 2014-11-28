set showtabline=2
set tabline=%!TabLine()

function TabLine()
    let s = ''
    for i in range (tabpagenr('$'))
        if (i + 1) == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        let s .= '  #' . (i+1) . ' '
        let buflist = tabpagebuflist((i+1))
        let winnr = tabpagewinnr((i+1))
        let filepath = bufname(buflist[winnr - 1])
        let filenamepos = match(filepath, '[^/]*$')
        if filenamepos == 0
            if strlen(filepath) == 0
                let s .= '(new file)'
            else
                let s .= filepath
            endif
        else
            let s .= strpart(filepath, filenamepos)
        endif

        let s .= '  '
    endfor
    let s .= '%#TabLineFill#%T'

    return s
endfunction
