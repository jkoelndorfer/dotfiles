lua <<EOF

vim.g.lsp_signature_config = {
    verbose = false,
    log_path = vim.fn.stdpath("cache") .. "/lsp-signature.log",
    hint_enable = false,
    always_trigger = true,
}
EOF
