let g:ctrlp_cmd = 'CtrlPMixed'
let ctrlp_mruf_max = 0

command CtrlPUnignoreVCS call CtrlPSetCommand(1)
command CtrlPIgnoreVCS call CtrlPSetCommand(0)

function CtrlPSetCommand(use_vcs_ignore)
    if a:use_vcs_ignore
        let vcs_ignore_option=''
    else
        let vcs_ignore_option='--skip-vcs-ignores'
    endif
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden ' . vcs_ignore_option . '
          \ --ignore .git
          \ --ignore .svn
          \ --ignore .hg
          \ --ignore .DS_Store
          \ --ignore "**/*.pyc"
          \ -g ""'
endfunction

" Default to using the VCS ignore file.
call CtrlPSetCommand(1)
