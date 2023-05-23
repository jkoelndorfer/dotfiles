local neorg = require('neorg')

neorg.setup({
  load = {
    ['core.defaults'] = {},
  },
})

function configure_neorg_settings()
  vim.api.nvim_win_set_option(0, 'conceallevel', 2)
  vim.api.nvim_buf_set_option(0, 'smartindent', false)
end

vim.api.nvim_create_augroup("neorg-personal", { clear = true })
vim.api.nvim_create_autocmd(
  {"FileType"},
  {
    pattern = 'norg',
    callback = configure_neorg_settings,
    group = 'neorg-personal',
  }
)
