if empty(glob(expand('$VIM_BUNDLE_DIR')))
    autocmd VimEnter * PlugInstall | silent! source $MYVIMRC
endif
call plug#begin(expand('$VIM_BUNDLE_DIR'))
    " git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'gregsexton/gitv'

    " motion, productivity
    Plug 'scrooloose/nerdtree'
    Plug 'freitass/todo.txt-vim'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tpope/vim-eunuch'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'kien/ctrlp.vim'
    Plug 'fholgado/minibufexpl.vim'
    Plug 'Raimondi/delimitMate'
    Plug 'tpope/vim-endwise'
    Plug 'junegunn/vim-easy-align'

    " styling, syntax highlighting
    Plug 'vim-scripts/diffchar.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'altercation/vim-colors-solarized'

    " tmux integration
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'epeli/slimux'
    Plug 'edkolev/tmuxline.vim'

    " programming-specific productivity
    Plug 'Shougo/neocomplcache.vim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'ervandew/supertab'
    Plug 'scrooloose/syntastic'
    Plug 'majutsushi/tagbar'
    Plug 'tomtom/tcomment_vim'

    " powershell
    Plug 'PProvost/vim-ps1'

    " python
    Plug 'nvie/vim-flake8'
    Plug 'davidhalter/jedi-vim'
    Plug 'klen/python-mode'

    " ruby
    Plug 'tpope/vim-rails'
    Plug 'vim-ruby/vim-ruby'
call plug#end()
