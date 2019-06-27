function! GitCommitMsgTemplate()
    let git_branch = toupper(system("git rev-parse --abbrev-ref HEAD"))
    let jira_project = matchstr(git_branch, '^[A-Z0-9]\+-[0-9]\+')
    let curline = getline('.')
    if jira_project != "" && curline !~ "^\s*\[" . jira_project "\]"
        exe "1s/^/[" . jira_project . "] /"
    endif
    normal $
endfunction

autocmd FileType gitcommit call GitCommitMsgTemplate()
