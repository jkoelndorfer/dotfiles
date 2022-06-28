for pfx in '' '/usr' '/usr/local'; do
    pathmunge "${pfx}/bin"
    pathmunge "${pfx}/sbin"
done
unset pfx

pathmunge "$HOME/bin"
pathmunge "$DOTFILE_DIR/bin"
pathmunge "$DOTFILE_DIR/bin/shell-profile"
