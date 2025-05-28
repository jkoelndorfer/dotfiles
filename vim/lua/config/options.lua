-- The LazyVim default is "unnamedplus", which causes text
-- deletion to replace the contents of your clipboard.
--
-- I do not know who thought this was a good idea. It isn't.
vim.o.clipboard = nil

vim.opt.listchars = "tab: ,trail: "
-- Highlight trailing whitespace because it's wrong and I hate it.
vim.cmd([[match ErrorMsg '\s\+$']])
