local git_index = '.git/index'

if not file_exists(git_index) then
  return
end

function configure_fugitive_tab()
  -- Here, prefer 'e .git/index' over :Git.
  --
  -- :Git will split the initial window and I'd rather
  -- the git status tab is fullscreen.
  vim.cmd('e ' .. git_index)
  vim.cmd('LualineRenameTab git')
  vim.cmd('tabnew')
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
