if vim.env.TERM ~= 'linux' then
  vim.cmd('silent! colorscheme nord')

  -- Make vim selection match tmux
  vim.cmd('hi Visual ctermbg=3 ctermfg=0')
end
