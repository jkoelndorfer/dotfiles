local treesitter_configs = require('nvim-treesitter.configs')

-- Treesitter plugins may require a newer compiler to build properly.
-- See:
--   * https://github.com/nvim-neorg/neorg#troubleshooting-treesitter
--   * https://github.com/nvim-neorg/neorg/issues/74#issuecomment-906627223
--   * https://github.com/nvim-neorg/neorg/discussions/888#discussioncomment-5953479
--
-- On Mac, `brew install gcc` and `CC=gcc-13 nvim` seemed to get things working.
treesitter_configs.setup({
  ensure_installed = {
    'lua',
    'markdown',
    'norg',
    'ruby',
    'python',
    'vim',
    'vimdoc',
  },

  highlight = {
    enable = true,
  },
})
