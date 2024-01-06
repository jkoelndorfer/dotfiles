vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'

configure_lang_settings({
  filetype = "python",
  indent_size = 4,
  max_line_len = 88,
  indent_with_tabs = false,
})
configure_lsp("python", "pyright", {vim.env.DOTFILE_DIR .. '/dev/language-servers/python'}, nil)

function ruff_on_attach(client, bufnr)
  client.server_capabilities.hoverProvider = false
end

function ruff_lsp_format()
  vim.lsp.buf.format({
    async = false,
    filter = function(client) return client.name ~= "ruff" end,
  })
end

configure_lsp("python", "ruff_lsp", {"ruff-lsp"}, ruff_on_attach)

vim.api.nvim_create_augroup("PythonAutofmt", { clear = true })
vim.api.nvim_create_autocmd(
  {"BufWritePre"},
  {
    pattern = {"*.py"},
    callback = ruff_lsp_format,
    group = "PythonAutofmt",
  }
)
