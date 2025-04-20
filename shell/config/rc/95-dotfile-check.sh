function _git_last_commit_timestamp() {
	command git --no-pager log --max-count 1 --format='%ct'
}

function dotfile_status() {
	pushd "$DOTFILE_DIR" >/dev/null

	local unpublished_commit_count=$(git_unpublished_commits)
	local last_commit_timestamp=$(_git_last_commit_timestamp)

	local last_install_run_timestamp
	if [[ -f "$_last_dotfile_install_path" ]]; then
		local last_install_run_timestamp=$(<"$_last_dotfile_install_path")
	fi
	if [[ -z "$last_install_run_timestamp" ]]; then
		last_install_run_timestamp=0
	fi
	if [[ "$unpublished_commit_count" -gt 0 ]]; then
		local unpublished_commit_msg="${fg_yellow} $unpublished_commit_count unpublished commits${color_reset}"
	fi
	if [[ -n "$(command git status --short)" ]]; then
		local uncommitted_changes_msg="${fg_red} uncommitted changes${reset_color}"
	fi
	if [[ "$last_commit_timestamp" -ge "$last_install_run_timestamp" ]]; then
		local install_run_msg="${fg_yellow} dotfile installation has not been run since last commit${color_reset}"
	fi

	popd >/dev/null

	if [[ -n "$unpublished_commit_msg" || -n "$uncommitted_changes_msg" || -n "$install_run_msg" ]]; then
		echo "${fg_blue} dotfiles${color_reset}"
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

if [[ "$ASCIINEMA_REC" == '1' ]]; then
	# Don't print the status of dotfiles if we're doing an asciinema recording.
	return
fi

if is-interactive-shell; then
	dotfile_status >&2
fi
