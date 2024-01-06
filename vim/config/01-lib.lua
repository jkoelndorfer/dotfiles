function do_nothing()
end

function configure_indent_size(w)
  for i, opt in pairs({'tabstop', 'softtabstop', 'shiftwidth'}) do
    vim.api.nvim_buf_set_option(0, opt, w)
  end
end

function configure_max_line_len(w)
  vim.api.nvim_buf_set_option(0, 'textwidth', w)
end

function configure_lang_settings(options)
  local filetype = options.filetype
  if filetype == nil then
    error("filetype must be specified")
  end

  local indent_size = options.indent_size
  if indent_size == nil then
    error("indent_size must be specified")
  end

  local max_line_len = options.max_line_len
  if max_line_len == nil then
    error("max_line_len must be specified")
  end

  local indent_with_tabs = options.indent_with_tabs
  if indent_with_tabs == nil then
    error("indent_with_tabs must be specified")
  end
  local addl_config = options.addl_config or do_nothing

  vim.api.nvim_create_autocmd(
    {"FileType"},
    {
      pattern = filetype,
      callback = function()
        configure_indent_size(indent_size)
        configure_max_line_len(max_line_len)
        addl_config()

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

function command_exists(cmd)
  -- FIXME: There ought to be a facility in Lua to execute
  -- a command given a program and a list of args. Google-fu
  -- is failing me right now, though.
  return os.execute('which ' .. cmd .. ' >/dev/null 2>&1') == 0
end
