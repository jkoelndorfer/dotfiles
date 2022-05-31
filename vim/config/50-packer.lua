-------------------
-- BOOTSTRAPPING --
-------------------

-- Taken from:
-- https://github.com/wbthomason/packer.nvim/blob/327568cd5270fe3299b1e51228a3541c0223e326/README.md#bootstrapping
-- with a few modifications.

local packer_repo = 'wbthomason/packer.nvim'
local packer_repo_url = 'https://github.com/' .. packer_repo

-- Ensure that the user runtimepath is always defined
-- See https://github.com/wbthomason/packer.nvim/issues/750
local user_rtp = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
vim.o.runtimepath = vim.o.runtimepath .. ',' .. user_rtp

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', packer_repo_url, install_path})
end

--------------------------
-- PLUGIN CONFIGURATION --
--------------------------

return require('packer').startup(function(use)
  -- Ensure that packer manages itself.
  -- If it doesn't, it will try to delete itself when neovim launches.
  use(packer_repo)

  ------------------
  -- TEXT EDITING --
  ------------------

  -- EasyMotion allows you to make large motions without having to count
  -- text objects.
  use 'easymotion/vim-easymotion'

  -- Align text easily.
  use 'junegunn/vim-easy-align'

  -- Comment and uncomment blocks of code.
  use 'scrooloose/nerdcommenter'

  -- Enable more efficient editing of function arguments.
  -- Defines argument text objects and motions between arguments.
  use 'PeterRincker/vim-argumentative'

  -----------
  -- THEME --
  -----------

  -- The Nord color scheme -- for vim.
  use 'arcticicestudio/nord-vim'

  -- Status and tabline for vim.
  use {
    'vim-airline/vim-airline',
    requires = {
      {'vim-airline/vim-airline-themes', opt = true},
    },
  }

  ---------------------
  -- VERSION CONTROL --
  ---------------------

  -- Provides :Git commands that behave better than simply invoking :!git.
  use 'tpope/vim-fugitive'

  -- Show VCS diffs in the sign column.
  use 'mhinz/vim-signify'

  ---------
  -- IDE --
  ---------

  -- Provides nifty vim commands for common unix operations, e.g.
  -- :Remove, :Rename, :Move, :SudoWrite, :SudoEdit
  use 'tpope/vim-eunuch'

  -- A highly-extensible fuzzy finder for neovim.
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    }
  }

  -- Display an overview of classes, methods, and functions defined in the current file.
  use 'majutsushi/tagbar'

  -- Provides a file tree.
  use { 'ms-jpq/chadtree', branch = 'chad', run = ':CHADdeps' }

  -- Automatically pull in project-specific configuration from .editorconfig files.
  use 'editorconfig/editorconfig-vim'

  -- Language server protocol (LSP) server configurations.
  use 'neovim/nvim-lspconfig'

  -- Run static analysis and type checking programs asynchronously.
  use 'neomake/neomake'

  -- Tab completion from a variety of sources, including an LSP server.
  use { 'ms-jpq/coq_nvim', branch = 'coq', run = ':COQdeps' }

  -- Provides function argument hints in a popup window as you type.
  use 'ray-x/lsp_signature.nvim'

  -----------
  -- DIFFS --
  -----------

  -- Use the Patience diff algorithm to produce (potentially) better diffs.
  use 'chrisbra/vim-diff-enhanced'

  -- Highlight the exact differences between two files in diff mode.
  use 'jkoelndorfer/diffchar.vim'

  ----------------------
  -- TMUX INTEGRATION --
  ----------------------

  -- Navigate seamlessly between vim windows and tmux panes.
  --
  -- NOTE: vim-tmux-navigator does NOT work properly inside `pipenv shell`.
  --
  -- See tmux/tmux.conf for more information.
  use 'christoomey/vim-tmux-navigator'

  -----------------------
  -- LANGUAGE-SPECIFIC --
  -----------------------

  -- Provides syntax highlighting and improved editing for Ansible.
  use 'pearofducks/ansible-vim'

  -- Adds comprehensive Go language support to vim, including language server
  -- integration, a ton of useful commands, and snippets.
  use {'fatih/vim-go', run = ':GoUpdateBinaries' }

  -- Provides syntax highlighting and improved editing for Python.
  use 'python-mode/python-mode'

  -- Formats Python code in accordance with the exceptionally precise Black standard.
  use { 'psf/black', tag = 'stable' }

  -- Provides syntax highlighting for Terraform.
  use 'hashivim/vim-terraform'

  -- Provides syntax highlighting, formatting, and syntax checking for Rust.
  use 'rust-lang/rust.vim'

  -- Improves vim's handling of YAML files.
  -- vim's builtin YAML syntax highlighting has a bug dealing with quotes.
  use 'stephpy/vim-yaml'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    packer.sync()
  end
end)
