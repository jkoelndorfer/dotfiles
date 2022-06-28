source "$DOTFILE_DIR"/zsh/config/rc/00-env-lib.zsh

for pfx in '' '/usr' '/usr/local'; do
    pathmunge "${pfx}/bin"
    pathmunge "${pfx}/sbin"
done
unset pfx

pathmunge "$HOME/bin"
pathmunge "$DOTFILE_DIR/bin"
pathmunge "$DOTFILE_DIR/bin/shell-profile"
