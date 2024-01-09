-- Line number configuration -- this uses the configuration described at
-- https://jeffkreeftmeijer.com/vim-number/ with some enhancements.
function toggle_relativenumber_on()
  if vim.api.nvim_win_get_option(0, 'number') then
    vim.api.nvim_win_set_option(0, 'relativenumber', true)
  end
end

function set_window_defaults()
  -- Don't show line breaks where there aren't any.
  vim.api.nvim_win_set_option(0, 'wrap', false)

  -- Fold code via indent.
  vim.api.nvim_win_set_option(0, 'foldmethod', 'indent')

  -- Turn on line numbers with relative numbers enabled.
  vim.api.nvim_win_set_option(0, 'number', true)
  vim.api.nvim_win_set_option(0, 'relativenumber', true)

  -- Always show the gutter (left of line numbers, where diff information appears).
  -- This keeps the line number area from resizing when a file is written in a
  -- git repository.
  vim.api.nvim_win_set_option(0, 'signcolumn', 'yes:1')

  vim.api.nvim_win_set_option(0, 'cursorline', false)

  vim.api.nvim_win_set_option(0, 'colorcolumn', '+0')

  vim.api.nvim_win_set_option(0, 'list', true)
end


-- Defines autocommands that enable relative line numbers when
-- a window is focused and we're in normal mode (for easier motions)
-- and disables relative line numbers at other times.
vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd(
  {"WinEnter", "BufEnter", "FocusGained", "InsertLeave"},
  { callback = toggle_relativenumber_on, group = "NumberToggle" }
)
vim.api.nvim_create_autocmd(
  {"WinLeave", "BufLeave", "FocusLost", "InsertEnter"},
  {
    callback = function() vim.api.nvim_win_set_option(0, "relativenumber", false) end,
    group = "NumberToggle",
  }
)

-- Defines autocommands that configure window defaults.
vim.api.nvim_create_augroup("WinDefaults", { clear = true })
vim.api.nvim_create_autocmd(
  {"VimEnter", "WinNew", "TabNew", "BufNewFile", "BufReadPre"},
  { callback = set_window_defaults, group = "WinDefaults" }
)

-- Don't theme the cursor -- a simple, solid block is sufficient.
-- If vim crashes and the cursor has been styled, it can get stuck
-- and need fixing.
vim.api.nvim_set_option('guicursor', '')

-- Configure tabs.
vim.api.nvim_set_option('expandtab', true)
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- By default, leave folds open.
vim.api.nvim_set_option('foldlevelstart', 99)

-- Configure indenting options.
vim.api.nvim_set_option('autoindent', true)
vim.api.nvim_set_option('smartindent', true)
vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_set_option('cindent', false)

-- Always show the status line
vim.api.nvim_set_option('laststatus', 3)

-- Try to keep the cursor in the middle of the window.
vim.api.nvim_set_option('scrolloff', 999)

-- Configure the behavior of the completion menu.
--
-- menuone:  Show menu even if there is only one match.
-- preview:  If there is extra information about the selected item,
--           show it in the preview window.
-- noinsert: Do not insert any text until an item is selected.
-- noselect: Do not automatically select a match from the menu.
vim.api.nvim_set_option('completeopt', 'menuone,preview,noinsert,noselect')

-- Configure the characters that appear for tabs and cut-off lines.
vim.api.nvim_set_option('listchars', 'tab:|-,extends:>,precedes:<')

-- Always permit backspace to delete in insert mode.
vim.api.nvim_set_option('backspace', 'indent,eol,start')

-- Show the partial normal-mode command being inputted.
vim.api.nvim_set_option('showcmd', true)

vim.api.nvim_set_option('diffopt', 'filler,algorithm:minimal,linematch:60,closeoff')

-- Configure undo.
vim.api.nvim_create_augroup("Undo", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter"}, { command = 'set undofile', group = "Undo" })
vim.api.nvim_set_option('undolevels', 1000)
vim.api.nvim_set_option('undoreload', 10000)

-- Trim all trailing whitespace before saving by default.
vim.g.trim_trailing_whitespace = 1
function trim_trailing_whitespace()
  -- Sometimes I work on projects that have lots of pre-existing trailing
  -- whitespace and don't want those changes getting mixed in with my commits.
  if vim.g.trim_trailing_whitespace == 1 then
    vim.v.errmsg = ''
    vim.cmd([[silent! %s/\s\+$//]])
    if vim.v.errmsg == '' then
      vim.cmd('normal ')
    end
  end
end
vim.api.nvim_create_augroup("TrimTrailingWhitespace", { clear = true })
vim.api.nvim_create_autocmd({"BufWritePre"}, { callback = trim_trailing_whitespace, group = "TrimTrailingWhitespace" })

-- Also highlight trailing whitespace, because it's wrong and I hate it.
vim.cmd([[match ErrorMsg '\s\+$']])

-- If $PROJECT_ROOT is set by our wrapper script, change to the project root
-- directory. Generally we want to be operating in the project root for
-- consistency and so things like Telescope behave better.
if vim.env.PROJECT_ROOT ~= nil and vim.env.PROJECT_ROOT ~= "" then
    vim.cmd('cd $PROJECT_ROOT')
end
