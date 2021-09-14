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
