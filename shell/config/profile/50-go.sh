_go_local_path="$HOME/.local/go"
export GOPATH="$_go_local_path:$HOME/src/go"

# Go utilities will end up here when we call GoInstallBinaries
# in vim. They need to be in the $PATH for completion to work
# correctly.
pathmunge "$_go_local_path/bin"

unset _go_local_path

(
	IFS=':'
	if [[ "$SHELL_NAME" == 'zsh' ]]; then
		setopt sh_word_split
	fi
	for d in $GOPATH; do
		if ! [[ -d "$d" ]]; then
			mkdir -p "$d"
		fi
	done
)
