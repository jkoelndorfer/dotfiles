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
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'klen/python-mode'
    NeoBundle 'epeli/slimux'
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'bling/vim-airline'
    NeoBundle 'dhruvasagar/vim-table-mode'
    NeoBundle 'tpope/vim-eunuch'
    NeoBundle 'freitass/todo.txt-vim'
    NeoBundle 'ervandew/supertab'
    NeoBundle 'edkolev/tmuxline.vim'

    " Needed for poshcomplete-vim
    NeoBundle 'mattn/webapi-vim'
    NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin'  : 'make -f make_cygwin.mak',
        \     'mac'     : 'make -f make_mac.mak',
        \     'linux'   : 'make',
        \     'unix'    : 'gmake',
        \    },
        \ }
call neobundle#end()
NeoBundleCheck
