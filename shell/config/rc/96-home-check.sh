function home_symlink_check() {
	local userdb_home
	local real_home

	userdb_home=$(getent passwd "$USER" | awk -F: '{ print $6 }')
	real_home=$(realpath "$userdb_home")

	if [[ "$userdb_home" != "$real_home" ]]; then
		printf '%s user DB $HOME does not match real path to home%s\n' "$fg_yellow" "$color_reset"
	fi
}

if is-interactive-shell; then
	home_symlink_check
fi
