function dotfile_status() {
    pushd "$DOTFILE_DIR" >/dev/null

    local unpublished_commit_count=$(git_unpublished_commits)
    if [[ "$unpublished_commit_count" -gt 0 ]]; then
        local unpublished_commit_msg="${fg[yellow]} $unpublished_commit_count unpublished commits${reset_color}"
    fi
    if [[ -n "$(git status --short)" ]]; then
        local uncommitted_changes_msg="${fg[red]} uncommitted changes${reset_color}"
    fi

    popd >/dev/null

    if [[ -n "$unpublished_commit_msg" || -n "$uncommitted_changes_msg" ]]; then
        echo "${fg[blue]} dotfiles${reset_color}"
        if [[ -n "$unpublished_commit_msg" ]]; then
            echo "  $unpublished_commit_msg"
        fi
        if [[ -n "$uncommitted_changes_msg" ]]; then
            echo "  $uncommitted_changes_msg"
        fi
        echo
    fi
}

dotfile_status >&2
