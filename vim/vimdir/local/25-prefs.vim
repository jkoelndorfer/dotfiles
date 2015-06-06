filetype plugin on

let mapleader=" "
nnoremap j gj
nnoremap k gk

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

" Indenting options
set autoindent
set smartindent
filetype indent on
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

" Configure undo sanely
set hidden

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

set clipboard^=unnamed

" Trim all trailing whitespace before saving
autocmd BufWritePre * %s/\s\+$//e
