nmap <C-p> <cmd>Telescope git_files<return>
nmap <C-M-p> <cmd>Telescope find_files<return>
nmap <C-b> <cmd>Telescope buffers<return>
nmap <C-g> <cmd>Telescope live_grep<return>

lua <<EOF
ts = require('telescope')
ts.setup({
    extensions = {
        fzf = {
            fuzzy = false,
        }
    }
})
ts.load_extension('fzf')
EOF
