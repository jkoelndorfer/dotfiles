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

" A custom patched DiffChar plugin is required to support user-defined
" highlights. Ordinarily DiffChar will overwrite these at runtime.
"
" My patched version checks if they're defined before setting them.
hi link dcDiffAdd DiffAdd
hi link dcDiffDelete DiffDelete
hi link dcDiffErase DiffDelete
hi dcDiffText ctermfg=3 cterm=reverse
