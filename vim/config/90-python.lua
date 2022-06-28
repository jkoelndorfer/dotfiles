configure_lang_settings("python", 4, 120, false)
configure_lsp("python", "pyright", {vim.env.DOTFILE_DIR .. '/dev/language-servers/python'}, nil)
