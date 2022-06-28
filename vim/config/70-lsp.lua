local lsp_map_opts = { noremap = true, silent = true }

vim.keymap.set('n', '<Leader>d', function() vim.diagnostic.open_float(nil, { focus = false }) end, lsp_map_opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.definition, lsp_map_opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, lsp_map_opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, lsp_map_opts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, lsp_map_opts)
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, lsp_map_opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, lsp_map_opts)

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
})

local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lspconfig = require('lspconfig')
local lsp_signature = require('lsp_signature')
local lsp_cap = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

function configure_lsp(filetype, lsp, cmd, on_attach)
  local lsp_setup = {
    capabilities = lsp_cap,
    on_attach = function()
      lsp_signature.on_attach(vim.g.lsp_signature_config)
      if on_attach ~= nil then
        on_attach()
      end
    end
  }
  if cmd ~= nil then
    lsp_setup['cmd'] = cmd
  end

  vim.api.nvim_create_autocmd(
    {"FileType"},
    {
      pattern = filetype,
      callback = function()
        l = lspconfig[lsp]
        l.setup(lsp_setup)
      end,
    }
  )
end
