-- The LazyVim default is "unnamedplus", which causes text
-- deletion to replace the contents of your clipboard.
--
-- I do not know who thought this was a good idea. It isn't.
vim.o.clipboard = nil

vim.opt.listchars = "tab: ,trail: "

-- Define a match group for trailing whitespace because it's wrong and I hate it.
vim.cmd([[match TrailingWhitespace '\s\+$']])
