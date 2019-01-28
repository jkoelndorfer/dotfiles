" UltiSnips documentation says we need this because the JumpBackwardTrigger
" is interfered with otherwise.
inoremap <C-x><C-k> <C-x><C-k>

let g:UltiSnipsSnippetDirectories=[expand("$DOTFILE_DIR") . "/vim/ultisnips", expand("$HOME") . "/.config/vimlocal/ultisnips"]
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
