_asdf_lib="$HOME/.asdf/asdf.sh"

function tool_manager_activate() {
	[[ "$MISE_ACTIVATED" == '1' ]] && return 0
	[[ "$ASDF_ACTIVATED" == '1' ]] && return 0

	# If mise is available, prefer it over asdf.
	#
	# Otherwise, if asdf is available, enable it.
	#
	# See https://github.com/asdf-vm/asdf.
	if type mise >/dev/null 2>&1; then
		mise_activate
	elif [[ -f "$_asdf_lib" ]]; then
		asdf_activate
	fi
}

function asdf_activate() {
	source "$_asdf_lib"
	ASDF_ACTIVATED=1
}

function mise_activate() {
	eval "$(mise activate)" >/dev/null 2>&1
	MISE_ACTIVATED=1
}
