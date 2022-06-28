function configure_indent_size(w)
  for i, opt in pairs({'tabstop', 'softtabstop', 'shiftwidth'}) do
    vim.api.nvim_buf_set_option(0, opt, w)
  end
end

function configure_max_line_len(w)
  vim.api.nvim_buf_set_option(0, 'textwidth', w)
end

function configure_lang_settings(filetype, indent_size, max_line_len, indent_with_tabs)
  vim.api.nvim_create_autocmd(
    {"FileType"},
    {
      pattern = filetype,
      callback = function()
        configure_indent_size(indent_size)
        configure_max_line_len(max_line_len)

        vim.api.nvim_buf_set_option(0, 'expandtab', not indent_with_tabs)
        vim.api.nvim_buf_set_option(0, 'smartindent', false)

        vim.cmd([[execute 'EditorConfigReload']])
      end,
    }
  )
end

function file_exists(path)
  local f = io.open(path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end
