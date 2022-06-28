local git_index = '.git/index'

if not file_exists(git_index) then
  return
end

function configure_fugitive_tab()
  vim.v.errmsg = ''
  vim.cmd('silent! tab Git')
  if vim.v.errmsg ~= '' then
    return
  end
  vim.cmd('LualineRenameTab git')
  vim.cmd('tabmove -1')
  vim.b.implicit_fugitive_buf = true
  vim.cmd('tabnext')
end

-- If the implicit fugitive's :Git is the last visible window,
-- quit vim automatically.
function exit_if_fugitive_window_last()
  only_has_fugitive_buffer = true
  for i, win in pairs(vim.api.nvim_list_wins()) do
    buf = vim.api.nvim_win_get_buf(win)
    status, result = pcall(function() return vim.api.nvim_buf_get_var(buf, 'implicit_fugitive_buf') end)
    if status and result == true then
      -- We got a fugitive buffer. Do nothing.
    else
      only_has_fugitive_buffer = false
    end
  end
  if only_has_fugitive_buffer then
    -- Note: quit will not occur if we have unwritten buffers.
    -- This is intentional!
    vim.cmd('silent! q')
  end
end

vim.api.nvim_create_augroup('FugitiveGitTab', { clear = true })
vim.api.nvim_create_autocmd(
  {'VimEnter'},
  {
    callback = configure_fugitive_tab,
    group = 'FugitiveGitTab',
    -- Required so that fugitive stuff works in this autocmd as expected.
    -- See https://github.com/tpope/vim-fugitive/issues/1554.
    nested = true,
  }
)
vim.api.nvim_create_autocmd(
  {'TabClosed'},
  {
    callback = exit_if_fugitive_window_last,
    group = 'FugitiveGitTab',
  }
)
