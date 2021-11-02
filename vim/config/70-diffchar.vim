" A custom patched DiffChar plugin is required to support user-defined
" highlights. Ordinarily DiffChar will overwrite these at runtime.
"
" My patched version checks if they're defined before setting them.
hi link dcDiffAdd DiffAdd
hi link dcDiffDelete DiffDelete
hi link dcDiffErase DiffDelete
hi dcDiffText ctermfg=3 cterm=reverse
