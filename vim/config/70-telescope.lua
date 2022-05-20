ts = require('telescope')
ts_func = require('telescope.builtin')

vim.api.nvim_set_keymap('n', '<C-p>', '', { noremap = true, callback = function() ts_func.git_files() end })
vim.api.nvim_set_keymap('n', '<C-M-p>', '', { noremap = true, callback = function() ts_func.find_files() end })
vim.api.nvim_set_keymap('n', '<C-b>', '', { noremap = true, callback = function() ts_func.buffers({ preview = true }) end })
vim.api.nvim_set_keymap('n', '<C-g>', '', { noremap = true, callback = function() ts_func.live_grep() end })

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
