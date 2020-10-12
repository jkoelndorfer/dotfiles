function! GitCommitMsgTemplate()
    if exists("b:git_commit_msg_template_executed")
        return
    endif

    let b:git_commit_msg_template_executed = 1
    let git_branch = toupper(system("git rev-parse --abbrev-ref HEAD"))
    let jira_project = matchstr(git_branch, '^[A-Z0-9]\+-[0-9]\+')

    let v:errmsg = ""
    " The ^M character below is required.
    normal! /Please enter
    if v:errmsg != ""
        return
    endif

    normal! kk0
    let l:curline = getline('.')
    if jira_project != "" && l:curline =~ "^\s*$"
        exe "normal o\<CR>" . jira_project
    endif
    normal! gg0
endfunction

" vim-fugitive does not have a Gadd command, but it does have Gwrite.
" For consistency, make Gadd an alias for Gwrite.
"
" See https://github.com/tpope/vim-fugitive/issues/558.
command! Gadd Gwrite

autocmd FileType gitcommit call GitCommitMsgTemplate()
