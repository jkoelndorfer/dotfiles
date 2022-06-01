require('nvim-tree').setup({
  filters = {
    custom = {
      "^\\.git",
    },
  },
})

vim.api.nvim_set_keymap('n', '<F8>', ':NvimTreeToggle<CR>', { noremap = true })
