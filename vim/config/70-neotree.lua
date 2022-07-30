require('neo-tree').setup()

vim.api.nvim_set_keymap('n', '<F8>', ':Neotree source=filesystem reveal=true position=left<CR>', { noremap = true })
