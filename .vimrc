call pathogen#infect()
set nocompatible
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
set statusline=#%n\ %-F\ %r\ %m\ %=\ [ASCII=%03.3b]\ [HEX=%02.2B]\ [POS=%04l,%04v,%P]
set laststatus=2
set completeopt=menu,longest,preview
set list listchars=tab:\|-,trail:_,extends:>,precedes:<

" Always show the tab line.
if version >= 700
    runtime tablinesetup.vim
endif

let g:solarized_bold=0
let g:solarized_italic=0
let g:solarized_visibility='med'
colorscheme solarized

" Tag List
" let Tlist_Display_Tag_Scope=1

" Keybinds

" E-mail signatures
nmap <buffer> <Leader>Sp o<Return>--<Esc>:r!grep -v '^\#' ~/.email-signature-personal<Return>
nmap <buffer> <Leader>Sc o<Return>--<Esc>:r!grep -v '^\#' ~/.email-signature-cems<Return>
nmap <buffer> <Leader>Su o<Return>--<Esc>:r!grep -v '^\#' ~/.email-signature-umn<Return>
ca w!! w !sudo tee "%" > /dev/null
