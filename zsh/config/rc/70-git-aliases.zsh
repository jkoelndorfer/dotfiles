function ga() {
    changed_files=$(git status --porcelain=2 | awk '{ print $9 }')
    selected_files=$(
        echo "$changed_files" | fzf --ansi --multi --preview='git diff --color=always {}'
    )
    old_ifs="$IFS"
    IFS=$'\n'
    if [[ -z "${=selected_files}" ]]; then
        return 1
    fi
    git add $@ ${=selected_files}
    IFS="$old_ifs"
}

function gb() {
    if [[ "$1" == "-a" ]]; then
        branch_addl_args='-a'
    fi
    branch="$(
        git branch -v $branch_addl_args --color=always |
        cut -c 3- |
        fzf --ansi --tiebreak length --preview='git log -n 10 --color=always $(echo {} | awk "{ print \$1 }")' |
        awk '{ print $1 }'
    )"
    [[ -n "$branch" ]] || return 1
    git checkout "$branch"
}

function gpu() {
    git push -u origin "$(git current-branch)"
}

function gc() {
    commit_msg_hook="$(git root)/.git/hooks/prepare-commit-msg"
    if ! [[ -x "$commit_msg_hook" ]]; then
        cp -f "$DOTFILE_DIR/git/hooks/prepare-commit-msg" "$commit_msg_hook"
    fi
    git commit --verbose $@
}

function gr() {
    local rebase_commit=$(
        git fzf-log |
        fzf --color "bg+:$SOLARIZED_BASE02_TERM16" --no-multi --ansi --preview='git log --patch -n 1 --color=always {1}' |
        awk '{ print $1 }'
    )
    if [[ -z "$rebase_commit" ]]; then
        return 1
    fi
    git rebase -i "${rebase_commit}~1" "$(git current-branch)"
}

alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gs='git status --short'
