max_line_length = 120
configure_lang_settings("python", 4, max_line_length, false)
configure_lsp("python", "pyright", {vim.env.DOTFILE_DIR .. '/dev/language-servers/python'}, nil)

function ruff_on_attach(client, bufnr)
  client.server_capabilities.hoverProvider = false
end

configure_lsp("python", "ruff_lsp", {"ruff-lsp"}, ruff_on_attach)

vim.api.nvim_exec("let g:pymode_options_max_line_length=" .. max_line_length, nil)
vim.api.nvim_exec("let g:pymode_lint=0", nil) -- ruff will lint for us
