for pfx in '' '/usr' '/usr/local'; do
    pathmunge "${pfx}/bin"
    pathmunge "${pfx}/sbin"
done
unset pfx

HOMEBREW_BIN_DIR='/opt/homebrew/bin'

if [[ -d "$HOMEBREW_BIN_DIR" ]]; then
  pathmunge "$HOMEBREW_BIN_DIR"
fi

pathmunge "${HOME}/.local/bin"
pathmunge "$HOME/bin"
pathmunge "$DOTFILE_DIR/bin"
