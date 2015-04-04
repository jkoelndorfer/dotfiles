filetype plugin on

let mapleader=" "

" Line numbers
set number
set cursorline

" Dark background terminal
set background=dark

" Setup tabs
set expandtab
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
" But leave folds open by default
set foldlevelstart=99

" Eliminate linebreaks where there aren't any
set nowrap
" But if we do turn wrapping on, break on word boundaries
" Unfortunately, this only works if we :set nolist
set linebreak

" Always show the status line
set laststatus=2

set completeopt=menu,longest,preview
set list listchars=tab:\|-,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set encoding=utf8

" Trim all trailing whitespace before saving
autocmd BufWritePre * %s/\s\+$//e
