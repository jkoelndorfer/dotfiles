ts = require('telescope')
ts_func = require('telescope.builtin')

-- Tries calling ts_func.git_files(), and if that fails (probably due to
-- us not being in a git repository), falls back to find_files().
function try_git_files()
  if not pcall(ts_func.git_files) then
    ts_func.find_files()
  end
end

vim.api.nvim_set_keymap('n', '<C-p>', '', { noremap = true, callback = try_git_files })
vim.api.nvim_set_keymap('n', '<C-M-p>', '', { noremap = true, callback = function() ts_func.find_files() end })
vim.api.nvim_set_keymap('n', '<C-b>', '', { noremap = true, callback = function() ts_func.buffers({ preview = true }) end })
vim.api.nvim_set_keymap('n', '<C-g>', '', { noremap = true, callback = function() ts_func.live_grep() end })
vim.api.nvim_set_keymap('n', '<C-f>', '', { noremap = true, callback = function() ts_func.lsp_references({ preview = true }) end })

ts.setup({
    defaults = {
        -- Previews cause telescope to hang for large, compacted JSON files.
        -- Those sometimes get stored in a repository as mock data for testing.
        preview = false
    },
    extensions = {
        fzf = {
            fuzzy = false,
        },
    },
})
ts.load_extension('fzf')
