" Taken from https://stackoverflow.com/a/37040415
"
" Identifies what syntax highlighting group is applied to the text
" under the cursor.
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction

let s:colors_rc = expand('$DOTFILE_DIR/theme/$DESKTOP_THEME/vim-colors.vim')
execute 'source ' . s:colors_rc

" Configure common diff options
hi clear DiffAdd
hi clear DiffDelete
hi clear DiffChange
hi clear DiffText

" Here, DiffText is left unset because vim's default diff display
" is pretty crappy and shows a lot more as a diff than there really is.
"
" DiffChar picks up the slack.
hi DiffAdd ctermfg=2 cterm=reverse
hi DiffDelete ctermfg=1 cterm=reverse
