HOMEBREW_BIN_DIR='/opt/homebrew/bin'

if [[ -d "$HOMEBREW_BIN_DIR" ]]; then
  pathmunge "$HOMEBREW_BIN_DIR"
fi
