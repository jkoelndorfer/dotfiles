# This file spits out a warning if some configuration isn't right.
# It's useful for the first-time setup that needs to happen on
# specific hosts, like configuring sensitive values or display
# names.

function print_config_warnings() {
	echo '##########################' >&2
	echo '# CONFIGURATION WARNINGS #' >&2
	echo '##########################' >&2
}

config_warnings=$({
	if [[ -z "$SYNCTHING_CENTRAL_DEVICE_ID" && -z "$SSH_CONNECTION" ]]; then
		echo '* $SYNCTHING_CENTRAL_DEVICE_ID is not configured; set it in ~/.shenv.secret'
	fi
})

if [[ "$ASCIINEMA_REC" == '1' ]]; then
	# Don't print configuration warnings if we're doing an asciinema recording.
	return
fi

if ! is-interactive-shell; then
	# Don't print configuration warnings in a non-interactive shell.
	return
fi

if [[ -n "$DISTROBOX_ENTER_PATH" ]] || [[ -n "$TOOLBOX_PATH" ]]; then
	# Don't print configuration warnings if we're running via a
	# Distrobox or Toolbox container.
	return
fi

if [[ -n "$config_warnings" ]]; then
	print_config_warnings
	echo "$config_warnings" >&2
fi
