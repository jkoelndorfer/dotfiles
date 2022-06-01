require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = vim.g.lualine_theme,
    globalstatus = true,
  },

  tabline = {
    lualine_b = {
      {
        'tabs',
        tabs_color = {
          active = 'lualine_a_normal',
          inactive = 'lualine_b_normal',
        },
      },
    },
  },
})
