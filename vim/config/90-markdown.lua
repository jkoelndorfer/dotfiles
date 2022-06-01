local job = require('plenary.job')

function preview_buffer_as_html()
  local j = job:new({
    command = 'pandoc',
    args = {vim.fn.expand('%'), '-o', '/tmp/vim-preview.html'},
  })
  j:start()
end

-- Automatically renders markdown files.
vim.api.nvim_create_augroup("MarkdownPreview", { clear = true })
vim.api.nvim_create_autocmd(
  {"BufWritePost"},
  {
    pattern = {"*.md"},
    callback = preview_buffer_as_html,
  }
)
