function is-interactive-shell() {
	if [[ "$SHELL_NAME" == 'bash' ]] && [[ "$-" == *i* ]]; then
		if [[ "$-" == *i* ]]; then
			return 0
		else
			return 1
		fi
	elif [[ "$SHELL_NAME" == 'zsh' ]]; then
		if [[ -o interactive ]]; then
			return 0
		else
			return 1
		fi
	fi

	printf 'cannot determine interactivity for unknown shell\n' >&2
	return 8
}

function regex-match() {
	local idx=$1

	if [[ "$SHELL_NAME" == 'bash' ]]; then
		printf '%s' "${BASH_REMATCH[$idx]}"
	elif [[ "$SHELL_NAME" == 'zsh' ]]; then
		printf '%s' "${match[$idx]}"
	else
		printf '%s: cannot get match for unknown shell\n' "$0" >&2
	fi
}
