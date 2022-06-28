STEAM_COMPATDATA_DIR="$HOME/.steam/steam/steamapps/compatdata"
SYNC_ROOT_DIR="$HOME/sync"
_FROMSOFT_TOKEN=''

function errmsg() {
	echo "$@" >&2
}

function fromsoft_token() {
	# FromSoft games (Dark Souls 1, 2, 3, and Elden Ring, at least) have a
	# data directory with a subdirectory whose name consists of hexadecimal digits.
	#
	# That subdirectory contains our save data.
	#
	# I don't know what the name of the subdirectory represents. Perhaps some type of
	# online user ID? If that is the case, I don't want to store it in version control.
	# Instead, store it in a file inside the sync directory. It would be possible to
	# determine the token automatically, but only if the game has been launched and
	# created save data locally.
	#
	# Symlinking the root data directory would be easier, but that contains graphics
	# configuration which will vary from system to system. It should not be synced.

	if [[ -n "$FROMSOFT_TOKEN" ]]; then
		echo "$FROMSOFT_TOKEN"
		return 0
	fi

	local fromsoft_token_path="$(sync_dir)/fromsoft-token"
	_FROMSOFT_TOKEN=$(< "$fromsoft_token_path")
	if [[ -z "$_FROMSOFT_TOKEN" ]]; then
		errmsg "Error determing FromSoft token from '$fromsoft_token_path'"
		exit 1
	fi
	echo "$_FROMSOFT_TOKEN"
}

function presetup_confirmation() {
	cat >&2
	local confirmed
    read -p 'proceed? (y/n) ' confirmed < /dev/tty
	if ! [[ "$(echo "$confirmed" | tr '[:upper:]' '[:lower:'])" =~ ^(yes|y)$ ]]; then
		errmsg "Aborting setup"
		exit 1
	fi
}

# This function is separate for easy testing in a REPL environment. :-)
function _proton_steamuser_home() {
	local steam_appid=$1

	echo "${STEAM_COMPATDATA_DIR}/${steam_appid}/pfx/drive_c/users/steamuser"
}

function proton_steamuser_home() {
	# Sourcing scripts should set STEAM_APPID as configuration.
	if [[ -z "$STEAM_APPID" ]]; then
		errmsg "$0: STEAM_APPID must be set!"
		exit 1
	fi
	_proton_steamuser_home "$STEAM_APPID"
}

function sync_dir() {
	# Config scripts should set SYNC_DIR as configuration.
	if [[ -z "$SYNC_DIR" ]]; then
		errmsg "$0: SYNC_DIR must be set!"
		exit 1
	fi
	echo "${SYNC_ROOT_DIR}/${SYNC_DIR}"
}

function symlink_abs() {
	local target=$1
	local link=$2

	local link_parent_dir="$(dirname "$link")"
	if ! mkdir -p "$link_parent_dir"; then
		errmsg "$0: failed to create $link_parent_dir"
		return 1
	fi

	if [[ -L "$link" ]]; then
		rm -f "$link"
	elif [[ -e "$link" ]]; then
		local link_backup="${link}.$(date +%s).bak"
		errmsg "$link already exists"
		errmsg "moving to $link_backup"
		mv "$link" "$link_backup" || return 2
	fi

	ln -v -s "$target" "$link"
}

function symlink() {
	local target=$1
	local link=$2

	symlink_abs "$(sync_dir)/${target}" "$link"
}
