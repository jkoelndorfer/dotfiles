require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = vim.g.lualine_theme,
    globalstatus = true,
    section_separators = { left = '', right = ' ' },
    component_separators = { left = '', right = ' ' },
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
