require('neo-tree').setup({
  default_component_configs = {
    icon = {
      -- neotree's default empty folder icon is "ﰊ",
      -- which if you're using nerd fonts looks nothing
      -- like a folder. Here, we fix it.
      folder_empty = ""
    }
  }
})

vim.api.nvim_set_keymap('n', '<F8>', ':Neotree source=filesystem reveal=true position=left<CR>', { noremap = true })
