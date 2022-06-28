source "$DOTFILE_DIR"/zsh/config/rc/00-env-lib.zsh

for pfx in '' '/usr' '/usr/local'; do
    pathmunge "${pfx}/bin"
    pathmunge "${pfx}/sbin"
done
unset pfx

# For macOS, some of the native utilities work better than
# the GNU coreutil variants. stty is one such example.
[[ -d "$DOTFILE_DIR/macos/binoverride" ]] && pathmunge "$DOTFILE_DIR/macos/binoverride"

pathmunge "$HOME/bin"
pathmunge "$DOTFILE_DIR/bin"
[[ -d "$DOTFILE_DIR/bin/shell-profile" ]] && pathmunge "$DOTFILE_DIR/bin/shell-profile"
