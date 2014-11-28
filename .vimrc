if has("win32")
    let &runtimepath=expand('$HOME') . '/dotfiles/.vim,' . &runtimepath
end
set nocompatible
" Configure NeoBundle
let &runtimepath=expand('$VIM_BUNDLE_DIR') . '/neobundle.vim,' . &runtimepath
call neobundle#begin(expand('$VIM_BUNDLE_DIR'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'altercation/vim-colors-solarized'
    NeoBundle 'Shougo/neocomplcache.vim'
    NeoBundle 'scrooloose/nerdtree'
    NeoBundle 'jistr/vim-nerdtree-tabs'
    NeoBundle 'Lokaltog/vim-easymotion'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'tomtom/tcomment_vim'
    NeoBundle 'PProvost/vim-ps1'
    NeoBundle 'nvie/vim-flake8'
    NeoBundle 'majutsushi/tagbar'
    NeoBundle 'techlivezheng/vim-plugin-minibufexpl'
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'klen/python-mode'
    NeoBundle 'epeli/slimux'
    NeoBundle 'tpope/vim-fugitive'
call neobundle#end()
NeoBundleCheck
filetype plugin on
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
set statusline=#%n\ %-F\ %r\ %m\ %=\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\"}\ [ASCII=%03.3b]\ [HEX=%02.2B]\ [POS=%04l,%04v,%P]
set laststatus=2
set completeopt=menu,longest,preview
set list listchars=tab:\|-,trail:_,extends:>,precedes:<
set backspace=indent,eol,start
set encoding=utf8

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
autocmd FileType python IndentGuidesEnable

" Always show the tab line.
if version >= 700
    runtime tablinesetup.vim
endif

let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='med'
colorscheme solarized

" Configure the IndentGuides plugin
" https://github.com/nathanaelkane/vim-indent-guides
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" Always show MiniBufExplorer
" If we don't always show MiniBufExplorer, vim-jedi gets very angry when it
" attempts to autocomplete.  vim becomes completely broken.
let g:miniBufExplBuffersNeeded=1

let g:syntastic_python_checkers = ['python']
let g:pymode_rope = 0

ca w!! w !sudo tee "%" > /dev/null
nmap <F8> :NERDTreeTabsToggle<CR>
nmap <F9> :TagbarToggle<CR>

" Slimux configuration
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>

" Easier moving between splits
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Trim all trailing whitespace before saving
autocmd BufWritePre * %s/\s\+$//e
