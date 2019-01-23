function! GitCommitMsgTemplate()
    let git_branch = toupper(system("git rev-parse --abbrev-ref HEAD"))
    let jira_project = matchstr(git_branch, '^[A-Z0-9]\+-[0-9]\+')
    if jira_project != ""
        exe "1s/^/[" . jira_project . "] /"
        normal $
    endif
endfunction

autocmd FileType gitcommit call GitCommitMsgTemplate()
