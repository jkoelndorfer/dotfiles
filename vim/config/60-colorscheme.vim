let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='normal'

" Highlight groups that link to Normal can cause weird backgrounds with the
" line highlighting (pymode specifically).
autocmd syntax * hi clear Normal
if !(expand('$TERM') == 'linux')
    silent! colorscheme solarized
    " Make visual-mode highlighting match tmux (and stand out more)
    hi Visual cterm=reverse ctermfg=3 guifg=Black guibg=Yellow

    hi DiffAdd    ctermfg=2       ctermbg=NONE guifg=2      guibg=NONE term=NONE gui=NONE
    hi DiffDelete ctermfg=1       ctermbg=1    guifg=1      guibg=1    term=NONE gui=NONE
    hi DiffChange ctermfg=NONE    ctermbg=NONE guifg=NONE   guibg=NONE term=NONE gui=NONE
    hi DiffText   ctermfg=3       ctermbg=NONE guifg=3      guibg=NONE term=NONE gui=NONE

    hi! link SignColumn LineNr
endif
