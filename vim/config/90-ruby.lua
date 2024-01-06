configure_lang_settings({
  filetype = "ruby",
  indent_size = 2,
  max_line_len = 120,
  indent_with_tabs = false
})
configure_lang_settings({
  filetype = "yaml",
  indent_size = 2,
  max_line_len = 120,
  indent_with_tabs = false
})
configure_lsp("ruby", "solargraph", nil, nil)
