vim.g.mapleader = ' '

vim.g.cache_dir = vim.env.XDG_CACHE_DIR

if vim.g.cache_dir == nil or vim.g.cache_dir == "" then
  vim.g.cache_dir = vim.env.HOME .. '/.cache'
end
