export PATH="${HOME}/bin:${HOME}/.local/bin:${DOTFILE_DIR}/jj/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"

HOMEBREW_BIN_DIR='/opt/homebrew/bin'

if [[ -d "$HOMEBREW_BIN_DIR" ]]; then
	pathmunge "$HOMEBREW_BIN_DIR"
fi
