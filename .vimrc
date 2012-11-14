if has("win32")
	let &runtimepath=expand('$HOME'). '/.vim,' . &runtimepath
end
set nocompatible
call pathogen#infect()
filetype plugin on
" Line numbers
set number
" Dark background terminal
set background=dark
" Setup tabs
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" No smart / C indenting -- use auto-identing, which is language agnostic
set autoindent
set nosmartindent
set nocindent
" Syntax highlighting
syntax on
" Code folding enabled based on indents
set foldmethod=indent
" Eliminate linebreaks where there aren't any
set nowrap
" But if we do turn wrapping on, break on word boundaries
" Unfortunately, tihs only works if we :set nolist
set linebreak
set statusline=#%n\ %-F\ %r\ %m\ %=\ [ASCII=%03.3b]\ [HEX=%02.2B]\ [POS=%04l,%04v,%P]
set laststatus=2
set completeopt=menu,longest,preview
set list listchars=tab:\|-,trail:_,extends:>,precedes:<
set bs=2

" Special setup for Python if we're using that
function! PythonSettings()
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal shiftwidth=4
	setlocal smarttab
	setlocal expandtab
	setlocal textwidth=80
	setlocal nosmartindent
	setlocal foldmethod=indent
endfunction
autocmd FileType python call PythonSettings()

" Always show the tab line.
if version >= 700
    runtime tablinesetup.vim
endif

let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='med'
colorscheme solarized

ca w!! w !sudo tee "%" > /dev/null
