local cmp = require('cmp')
local keymap = require('cmp.utils.keymap')
local lspkind = require('lspkind')

function tab_complete_buf()
  local curcol = vim.fn.getcurpos()[3]
  local ln_to_cursor = string.sub(vim.fn.getline('.'), 0, curcol - 1)
  if string.find(ln_to_cursor, '^%s*$') ~= nil then
    vim.api.nvim_feedkeys(keymap.t('<Tab>'), 'n', true)
  else
    cmp.complete()
  end
end

function tab_complete_cmdline(cmp_visible)
  return function()
    if cmp.visible() then
      cmp_visible()
    else
      cmp.complete()
    end
  end
end

vim.api.nvim_set_keymap('i', '<Tab>', '', { callback = tab_complete_buf })

cmp.setup({
  completion = {
    autocomplete = false,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol',
      menu = {
        buffer = '[buf]',
        cmdline = '[cmdline]',
        nvim_lsp = '[lsp]',
        path = '[path]',
      }
    }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp', group_index = 1 },
    { name = 'buffer', group_index = 2 },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
})

vim.api.nvim_set_keymap('c', '<Tab>', '', { callback = tab_complete_cmdline(cmp.select_next_item) })
vim.api.nvim_set_keymap('c', '<S-Tab>', '', { callback = tab_complete_cmdline(cmp.select_prev_item) })

-- When searching, only complete from the current buffer.
cmp.setup.cmdline('/', {
  mapping = {},
  sources = {
    { name = 'buffer' },
  },
})
cmp.setup.cmdline('?', {
  mapping = {},
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = {},
  sources = cmp.config.sources({
    { name = 'path', group_index = 1 },
    { name = 'cmdline', group_index = 2 },
    { name = 'buffer', group_index = 3 }, -- For :s
  }),
})
