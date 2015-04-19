let &runtimepath=expand('$VIM_BUNDLE_DIR') . '/neobundle.vim,' . &runtimepath
call neobundle#begin(expand('$VIM_BUNDLE_DIR'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    " git
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'airblade/vim-gitgutter'
    NeoBundle 'gregsexton/gitv'

    " motion, productivity
    NeoBundle 'scrooloose/nerdtree'
    NeoBundle 'freitass/todo.txt-vim'
    NeoBundle 'jistr/vim-nerdtree-tabs'
    NeoBundle 'dhruvasagar/vim-table-mode'
    NeoBundle 'tpope/vim-eunuch'
    NeoBundle 'Lokaltog/vim-easymotion'
    NeoBundle 'tpope/vim-surround'

    " styling, syntax highlighting
    NeoBundle 'bling/vim-airline'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'altercation/vim-colors-solarized'

    " tmux integration
    NeoBundle 'epeli/slimux'
    NeoBundle 'edkolev/tmuxline.vim'

    " programming-specific productivity
    NeoBundle 'Shougo/neocomplcache.vim'
    NeoBundle 'ervandew/supertab'
    NeoBundle 'scrooloose/syntastic'
    NeoBundle 'majutsushi/tagbar'
    NeoBundle 'tomtom/tcomment_vim'

    " powershell
    NeoBundle 'PProvost/vim-ps1'

    " python
    NeoBundle 'nvie/vim-flake8'
    NeoBundle 'davidhalter/jedi-vim'
    NeoBundle 'klen/python-mode'

    " ruby
    NeoBundle 'tpope/vim-rails'
    NeoBundle 'vim-ruby/vim-ruby'
call neobundle#end()
NeoBundleCheck
