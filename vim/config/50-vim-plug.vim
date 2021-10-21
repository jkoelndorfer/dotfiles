call plug#begin(expand('$VIM_BUNDLE_DIR'))
    " git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'gregsexton/gitv'

    " motion, productivity
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tpope/vim-eunuch'
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-endwise'
    Plug 'junegunn/vim-easy-align'
    Plug 'SirVer/ultisnips'
    Plug 'chrisbra/vim-diff-enhanced'
    Plug 'scrooloose/nerdtree'
    Plug 'vimwiki/vimwiki'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'branch': 'main', 'do': 'make' }

    " styling, syntax highlighting
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'arcticicestudio/nord-vim'

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
    Plug 'neovim/nvim-lspconfig'
    Plug 'ray-x/lsp_signature.nvim'

    " completion
    Plug 'ncm2/ncm2'

    " nvim-yarp is required by ncm2
    Plug 'roxma/nvim-yarp'

    " ncm2 completion plugins
    Plug 'ncm2/ncm2-vim-lsp'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-tmux'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-ultisnips'
    Plug 'fgrsnau/ncm2-otherbuf'

    " ansible
    Plug 'pearofducks/ansible-vim'

    " go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " python
    Plug 'python-mode/python-mode'
    Plug 'psf/black', { 'tag': '21.8b0' }

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
