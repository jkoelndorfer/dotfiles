call plug#begin(expand('$VIM_BUNDLE_DIR'))
    " git
    Plug 'tpope/vim-fugitive'
    Plug 'gregsexton/gitv'

    " motion, productivity
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tpope/vim-eunuch'
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-endwise'
    Plug 'junegunn/vim-easy-align'
    Plug 'SirVer/ultisnips'
    Plug 'vimwiki/vimwiki'
    Plug 'ms-jpq/chadtree', { 'branch': 'chad' }

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'branch': 'main', 'do': 'make' }

    " styling, syntax highlighting
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'arcticicestudio/nord-vim'

    " diff improvements
    Plug 'chrisbra/vim-diff-enhanced'
    Plug 'jkoelndorfer/diffchar.vim'
    Plug 'mhinz/vim-signify'

    " tmux integration

    " NOTE: vim-tmux-navigator does NOT work properly inside `pipenv shell`.
    "
    " See tmux/tmux.conf for more information.
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'epeli/slimux'

    " programming-specific productivity
    Plug 'neomake/neomake'
    Plug 'majutsushi/tagbar'
    Plug 'scrooloose/nerdcommenter'
    Plug 'PeterRincker/vim-argumentative'
    Plug 'editorconfig/editorconfig-vim'

    " completion
    Plug 'neovim/nvim-lspconfig'
    Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }
    Plug 'ray-x/lsp_signature.nvim'

    " ansible
    Plug 'pearofducks/ansible-vim'

    " go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " python
    Plug 'python-mode/python-mode'
    Plug 'psf/black', { 'tag': 'stable' }

    " markdown
    Plug 'JamshedVesuna/vim-markdown-preview'

    " terraform
    Plug 'hashivim/vim-terraform'

    " rust
    Plug 'rust-lang/rust.vim'

    " yaml
    " vim's builtin yaml syntax highlighting has a bug dealing with quotes
    Plug 'stephpy/vim-yaml'
call plug#end()
