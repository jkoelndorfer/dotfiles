call plug#begin(expand('$VIM_BUNDLE_DIR'))
    " git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'gregsexton/gitv'

    " motion, productivity
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tpope/vim-eunuch'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'kien/ctrlp.vim'
    Plug 'fholgado/minibufexpl.vim'
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

    " programming-specific productivity
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'ervandew/supertab'
    Plug 'neomake/neomake'
    Plug 'majutsushi/tagbar'
    Plug 'tomtom/tcomment_vim'

    " python
    Plug 'davidhalter/jedi-vim'
    Plug 'klen/python-mode'
    Plug 'zchee/deoplete-jedi'

    " ruby
    Plug 'tpope/vim-rails'
    Plug 'vim-ruby/vim-ruby'
call plug#end()
