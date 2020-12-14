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

function git-ls-directories() {
    # This is an attempt at creating a sort of fast (but not 100% accurate)
    # list of directories in a git repository, including untracked ones.
    #
    # git ls-files will not produce a list of directories, so we need to
    # massage its output a little bit.
    #
    # grep excludes files without any '/', which are definitely not directories.
    # sed then strips off the last component of the path.
    # Lastly, sort -u ensures there are no duplicate directory entries.
    #
    # Untracked empty directories will not be discovered using this method.
    # git ls-files does not report them.
    {
        local root=$(git root)
        git ls-files --full-name "$root"
        git ls-files --exclude-standard -o --full-name "$root"
    } | grep '/' | sed -r -e 's#/[^/]+$##' | sort -u
}

function gcd() {
    local target_directory=$(git-ls-directories | fzf)
    if [[ -z "$target_directory" ]]; then
        return 1
    fi
    cd "$(git root)/$target_directory"
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

function git() {
    local subfunc=$1
    local user_email_config=$(command git config --local -l 2>/dev/null | grep 'user\.email')

    if [[ -z "$user_email_config" ]] && ! [[ "$subfunc" =~ ^(clone|init|config|log|status)$ ]]; then
        echo 'fatal: set git config option `user.email` for this repository' >&2
        return 1
    fi

    command git "$@"
}

alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gs='git status --short'
