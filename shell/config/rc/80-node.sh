function source_nvm() {
	if [[ -f 'package.json' ]]; then
		if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
			source "$HOME/.nvm/nvm.sh"
		else
			echo "WARN: $HOME/.nvm/nvm.sh does not exist; can't use nvm" >&2
		fi
	fi
}

if [[ "$SHELL_NAME" == 'zsh' ]]; then
	chpwd_functions=("${chpwd_functions[@]}" source_nvm)
fi
