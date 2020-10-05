function! GitCommitMsgTemplate()
    let git_branch = toupper(system("git rev-parse --abbrev-ref HEAD"))
    let jira_project = matchstr(git_branch, '^[A-Z0-9]\+-[0-9]\+')

    " The ^M character below is required.
    normal /Please enter

    normal kk0
    let l:curline = getline('.')
    echom l:curline
    if jira_project != "" && l:curline =~ "^\s*$"
        exe "normal o\<CR>" . jira_project
    endif
    normal gg0
endfunction

" vim-fugitive does not have a Gadd command, but it does have Gwrite.
" For consistency, make Gadd an alias for Gwrite.
"
" See https://github.com/tpope/vim-fugitive/issues/558.
command! Gadd Gwrite

autocmd FileType gitcommit call GitCommitMsgTemplate()
