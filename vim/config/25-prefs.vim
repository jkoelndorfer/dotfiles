filetype plugin on
if &omnifunc == ''
    set omnifunc=syntaxcomplete#Complete
endif

" Huge performance boost if working in a terminal
set ttyfast

" Makes global search/replace nicer
if has('nvim')
    set inccommand=nosplit
endif

nnoremap j gj
nnoremap k gk

" Line number configuration -- this uses the configuration described at
" https://jeffkreeftmeijer.com/vim-number/ with some enhancements.
function Toggle_relativenumber_on()
    if &number
        set relativenumber
    end
endfunction

set number
set relativenumber

augroup numbertoggle
    autocmd!
    autocmd WinEnter,BufEnter,FocusGained,InsertLeave * call Toggle_relativenumber_on()
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup end

set cursorline

" Dark background terminal
set background=dark

set guicursor=

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

" Keep some context around the cursor all the time
set scrolloff=999

if !has('nvim') || v:version < 800
    set completeopt=menuone,preview,longest
else
    set completeopt=menuone,preview,noinsert,noselect
endif
set list listchars=tab:\|-,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set encoding=utf8

" Show normal mode command keys as they are being entered.
set showcmd

" Configure undo sanely
set hidden

set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

" Trim all trailing whitespace before saving by default.
let g:trim_trailing_whitespace = 1
function TrimTrailingWhitespace()
    " Sometimes I work on projects that have lots of pre-existing trailing
    " whitespace and don't want those changes getting mixed in with my commits.
    if g:trim_trailing_whitespace == 1
        execute '%s/\s\+$//e'
    endif
endfunction

autocmd BufWritePre * call TrimTrailingWhitespace()
