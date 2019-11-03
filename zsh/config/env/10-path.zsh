# Configure a basic path if there is not one. Should be fine for most use cases.
[[ -z "$PATH" ]] && PATH="/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
source "$DOTFILE_DIR"/zsh/config/rc/00-env-lib.zsh
pathmunge "$DOTFILE_DIR/bin"
[[ -d "$HOME/bin" ]] && pathmunge "$HOME/bin"
