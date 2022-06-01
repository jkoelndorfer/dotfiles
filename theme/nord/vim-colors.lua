if vim.env.TERM ~= 'linux' then
  vim.cmd('silent! colorscheme nord')

  -- Make vim selection match tmux
  vim.cmd('hi Visual ctermbg=3 ctermfg=0')
end

vim.api.nvim_set_option('termguicolors', true)

local lualine_theme = require('lualine.themes.nord')

-- Make lualine consistent with the tmux status line.
lualine_theme.normal.a.bg = '#81a1c1'
lualine_theme.normal.b.bg = '#4c566a'
lualine_theme.normal.c.bg = '#3b4252'

vim.g.lualine_theme = lualine_theme
