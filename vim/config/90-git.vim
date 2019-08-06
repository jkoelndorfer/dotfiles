function! GitCommitMsgTemplate()
    let git_branch = toupper(system("git rev-parse --abbrev-ref HEAD"))
    let jira_project = matchstr(git_branch, '^[A-Z0-9]\+-[0-9]\+')
    let curline = getline('.')
    if jira_project != "" && curline !~ "^\s*\[" . jira_project "\]"
        exe "1s/^/[" . jira_project . "] /"
    endif
    normal $
endfunction

" vim-fugitive does not have a Gadd command, but it does have Gwrite.
" For consistency, make Gadd an alias for Gwrite.
"
" See https://github.com/tpope/vim-fugitive/issues/558.
command Gadd Gwrite

autocmd FileType gitcommit call GitCommitMsgTemplate()
