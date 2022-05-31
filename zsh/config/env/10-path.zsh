# Configure a basic path if there is not one. Should be fine for most use cases.
[[ -z "$PATH" ]] && PATH="/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
source "$DOTFILE_DIR"/zsh/config/rc/00-env-lib.zsh

# For macOS, some of the native utilities work better than
# the GNU coreutil variants. stty is one such example.
[[ -d "$DOTFILE_DIR/macos/binoverride" ]] && pathmunge_reorder "$DOTFILE_DIR/macos/binoverride"

pathmunge_reorder "$HOME/bin"
pathmunge_reorder "$DOTFILE_DIR/bin"
[[ -d "$DOTFILE_DIR/bin/shell-profile" ]] && pathmunge_reorder "$DOTFILE_DIR/bin/shell-profile"
