nmap <C-p> <cmd>Telescope git_files<return>
nmap <C-M-p> <cmd>Telescope find_files<return>
nmap <C-b> <cmd>Telescope buffers<return>
nmap <C-g> <cmd>Telescope live_grep<return>

lua <<EOF
ts = require('telescope')
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
EOF
