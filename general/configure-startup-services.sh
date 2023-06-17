#!/bin/bash

if [[ "$(uname)" != 'Linux' ]]; then
	printf 'configuring startup services is only supported on Linux' >&2

	# exit 0 so dotfile installation succeeds on non-Linux systems
	exit 0
fi

enabled_services=(
	'ststatus.service'   # This is provided by this repository
	'syncthing.service'  # This is provided by Arch Linux's syncthing package
)

for svc in "${enabled_services[@]}"; do
	systemctl --user enable --now "$svc"
done
