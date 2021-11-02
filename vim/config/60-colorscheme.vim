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
