call plug#begin(expand('$VIM_BUNDLE_DIR'))
    " git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'gregsexton/gitv'

    " motion, productivity
    Plug 'francoiscabrol/ranger.vim'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tpope/vim-eunuch'
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-endwise'
    Plug 'junegunn/vim-easy-align'
    Plug 'SirVer/ultisnips'
    Plug 'chrisbra/vim-diff-enhanced'
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    " styling, syntax highlighting
    Plug 'vim-scripts/diffchar.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'altercation/vim-colors-solarized'

    " tmux integration

    " NOTE: vim-tmux-navigator does NOT work properly inside `pipenv shell`.
    "
    " See tmux/tmux.conf for more information.
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'epeli/slimux'

    " programming-specific productivity
    Plug 'neomake/neomake'
    Plug 'majutsushi/tagbar'
    Plug 'tomtom/tcomment_vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'PeterRincker/vim-argumentative'

    " completion
    Plug 'ncm2/ncm2'

    " nvim-yarp is required by ncm2
    Plug 'roxma/nvim-yarp'

    " ncm2 completion plugins
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-tmux'
    Plug 'ncm2/ncm2-path'

    " ansible
    Plug 'pearofducks/ansible-vim'

    " python
    Plug 'ncm2/ncm2-jedi'
    Plug 'klen/python-mode'

    " go
    Plug 'fatih/vim-go'

    " markdown
    Plug 'JamshedVesuna/vim-markdown-preview'

    " ruby
    Plug 'roxma/ncm-rct-complete'
    Plug 'tpope/vim-rails'
    Plug 'vim-ruby/vim-ruby'

    " terraform
    Plug 'hashivim/vim-terraform'

    " typescript
    Plug 'leafgarland/typescript-vim'

    " yaml
    " vim's builtin yaml syntax highlighting has a bug dealing with quotes
    Plug 'stephpy/vim-yaml'
call plug#end()
