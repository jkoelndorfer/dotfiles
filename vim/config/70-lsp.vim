let g:lsp_border = [
    \ ["+", "FloatBorder"],
    \ ["-", "FloatBorder"],
    \ ["+", "FloatBorder"],
    \ ["|", "FloatBorder"],
    \ ["+", "FloatBorder"],
    \ ["-", "FloatBorder"],
    \ ["+", "FloatBorder"],
    \ ["|", "FloatBorder"],
\ ]
nmap <Leader>gd :lua vim.lsp.buf.definition()<CR>
nmap K :lua vim.lsp.buf.hover({ popup_opts = { border = "single" }})<CR>
nmap <Leader>r :lua vim.lsp.buf.rename()<CR>
nmap <Leader>d :lua vim.diagnostic.open_float(nil, {focus=false})<CR>

lua <<EOF
    vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = true,
        update_in_insert = true,
        severity_sort = true,
    })
EOF
