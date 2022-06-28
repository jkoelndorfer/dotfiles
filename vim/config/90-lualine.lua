require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = vim.g.lualine_theme,
    globalstatus = true,
    section_separators = { left = '', right = ' ' },
    component_separators = { left = '', right = ' ' },
  },

  sections = {
    lualine_c = {
      {
        'filename',
        path = 1, -- Show relative path of file, not just the filename
      },
    },
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
