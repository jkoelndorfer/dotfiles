# If the Flatpak version of Steam, set this to
# the directory that the "user's home" will be located
# in. Probably: "${HOME}/.var/app/com.valvesoftware.Steam"
if [[ -z "$STEAM_HOME" ]]; then
	STEAM_HOME="${HOME}"
fi
if [[ -z "$STEAM_LIBRARY_ROOT" ]]; then
	STEAM_LIBRARY_ROOT="${STEAM_HOME}/.steam/steam"
fi
STEAM_APPS_COMMON_DIR="${STEAM_LIBRARY_ROOT}/steamapps/common"
STEAM_COMPATDATA_DIR="${STEAM_LIBRARY_ROOT}/steamapps/compatdata"
SYNC_ROOT_DIR="$HOME/sync"

function errmsg() {
	echo "$@" >&2
}

function force_cp() {
	local src=$1
	local dest=$2

	if [[ -z "$src" ]]; then
		errmsg "$0: missing required src"
		exit 1
	fi

	if [[ -z "$dest" ]]; then
		errmsg "$0: missing required dest"
	fi

	rm -rf "$dest"
	cp -rv "$src" "$dest"
}

function game_data() {
	# Some games save their data in a directory based on an online user ID.
	#
	# For games distributed by Steam, this is often some form of the account's
	# Steam ID [1]. In order to support the varying forms that a game might use
	# to represent the Steam ID (and prevent account ID exposure), we store the
	# ID in the sync directory.
	#
	# [1]: https://developer.valvesoftware.com/wiki/SteamID
	local data_file
	data_file="$(sync_dir)/${1}"

	local data
	data=$(<"$data_file")
	if [[ -z "$data" ]]; then
		errmsg "Error reading data from '$data_file'"
		exit 1
	fi
	echo "$data"
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
