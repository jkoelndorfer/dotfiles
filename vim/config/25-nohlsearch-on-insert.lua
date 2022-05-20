-- When entering insert mode, highlighted search
-- results are distracting so let's turn them off.
vim.api.nvim_create_autocmd({'InsertEnter'}, {
  command = 'setlocal nohlsearch'
})

-- When using any search functionality, re-enable
-- highlights so matches stand out.
for i, key in pairs({'/', '?', 'n', 'N', '#', '*'}) do
  vim.api.nvim_set_keymap('n', key, ':setlocal hlsearch<CR>' .. key, { noremap = true })
end
