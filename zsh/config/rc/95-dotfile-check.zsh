function _git_last_commit_timestamp() {
    git --no-pager log --max-count 1 --format='%ct'
}

function dotfile_status() {
    pushd "$DOTFILE_DIR" >/dev/null

    local unpublished_commit_count=$(git_unpublished_commits)
    local last_commit_timestamp=$(_git_last_commit_timestamp)
    local last_install_run_timestamp=$( (< "$_last_dotfile_install_path" || echo '0') 2>/dev/null )
    if [[ "$unpublished_commit_count" -gt 0 ]]; then
        local unpublished_commit_msg="${fg[yellow]} $unpublished_commit_count unpublished commits${reset_color}"
    fi
    if [[ -n "$(git status --short)" ]]; then
        local uncommitted_changes_msg="${fg[red]} uncommitted changes${reset_color}"
    fi
    if [[ "$last_commit_timestamp" -ge "$last_install_run_timestamp" ]]; then
        local install_run_msg="${fg[yellow]} dotfile installation has not been run since last commit${reset}"
    fi

    popd >/dev/null

    if [[ -n "$unpublished_commit_msg" || -n "$uncommitted_changes_msg" || -n "$install_run_msg" ]]; then
        echo "${fg[blue]} dotfiles${reset_color}"
        if [[ -n "$install_run_msg" ]]; then
            echo "  $install_run_msg"
        fi
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
