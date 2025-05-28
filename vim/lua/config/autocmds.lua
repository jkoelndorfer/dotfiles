vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function()
		vim.wo.conceallevel = 0
	end,
})

-- In shell scripts, heredocs can be auto-dedented if tabs
-- are used instead of spaces. For that reason, prefer
-- tabs in shell scripts.
--
-- https://stackoverflow.com/questions/33815600/indenting-heredocs-with-spaces
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "shell" },
	callback = function()
		vim.o.expandtab = false
	end,
})
