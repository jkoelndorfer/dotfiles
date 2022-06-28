local git_index = '.git/index'

if not file_exists(git_index) then
  return
end

function configure_fugitive_tab()
  vim.cmd('tab Git')
  vim.cmd('LualineRenameTab git')
  vim.cmd('tabmove -1')
  vim.cmd('tabnext')
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
