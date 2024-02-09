-- Close a buffer
-- Taken from https://stackoverflow.com/a/8585343
vim.api.nvim_set_keymap('n', '<Leader>bd', ':bp | sp | bn | bd<CR>', { noremap = true })

-- Maintain visual mode selection when adjusting indentation
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Toggle paste mode to paste some stuff in from tmux or the clipboard
vim.api.nvim_set_keymap('n', '<Leader>p', ':set paste!<CR>', { noremap = true })

-- Paste directly from the clipboard
vim.api.nvim_set_keymap('n', '<Leader>P', ':r! $DOTFILE_DIR/bin/gui/paste-from-clipboard<CR>', { noremap = true })

-- Move between splits more easily
for i, dir in pairs({'h', 'j', 'k', 'l'}) do
  vim.api.nvim_set_keymap('n', '<C-' .. dir .. '>', '<C-w>' .. dir, { noremap = true })
end

-- Disable ex mode. Who even uses that?
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gQ', '<Nop>', { noremap = true })

-- Shortcut for quitting an entire tmux project tab.
vim.api.nvim_set_keymap('n', 'QQQ', ':QuitTab<CR>', { noremap = true })
