local nord_theme = {
  nord0 = '#2e3440',
  nord1 = '#3b4252',
  nord2 = '#434c5e',
  nord3 = '#4c566a',
  nord4 = '#d8dee9',
  nord5 = '#e5e9f0',
  nord6 = '#eceff4',
  nord7 = '#8fbcbb',
  nord8 = '#88c0d0',
  nord9 = '#81a1c1',
  nord10 = '#5e81ac',
  nord11 = '#bf616a',
  nord12 = '#d08770',
  nord13 = '#ebcb8b',
  nord14 = '#a3be8c',
  nord15 = '#b48ead',
}

if vim.env.TERM ~= 'linux' then
  vim.cmd('silent! colorscheme nord')

  -- Make vim selection match tmux
  vim.cmd('hi Visual ctermbg=3 ctermfg=0')
end

vim.api.nvim_set_option('termguicolors', true)

local lualine_theme = require('lualine.themes.nord')

-- Make lualine consistent with the tmux status line.
lualine_theme.normal.a.bg = nord_theme.nord9
lualine_theme.normal.b.bg = nord_theme.nord3
lualine_theme.normal.c.bg = nord_theme.nord1

vim.g.lualine_theme = lualine_theme

-- Tweak nvim-tree.lua colors.
--
-- Lua doesn't do string interpolation, hence the string.gsub
-- business here. The replacement will substitute e.g. "$nord0"
-- for the value of "nord0" in the given table.
--
-- See: https://hisham.hm/2016/01/04/string-interpolation-in-lua/
vim.cmd(string.gsub([[
  highlight Directory guifg=$nord9
  highlight link NvimTreeRootFolder Directory

  highlight NvimTreeSymlink gui=bold guifg=$nord8
  highlight NvimTreeExecFile gui=bold guifg=$nord14
]], "%$(%w+)", nord_theme))
