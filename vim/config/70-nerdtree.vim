nmap <F7> :NerdTreeToggle<CR>
nmap <F8> :NERDTreeFocus<CR>

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "",
    \ "Staged"    : "",
    \ "Untracked" : "",
    \ "Renamed"   : "",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "",
    \ "Dirty"     : "",
    \ "Clean"     : "",
    \ 'Ignored'   : '∕',
    \ "Unknown"   : "?"
    \ }

let NERDTreeIgnore = [
    \ '\~$',
    \ '^__pycache__$',
    \ '.pyc$'
    \ ]
