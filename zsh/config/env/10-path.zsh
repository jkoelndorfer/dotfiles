# Configure a basic path if there is not one. Should be fine for most use cases.
[[ -z "$PATH" ]] && PATH="/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
for f in "$DOTFILE_DIR"/zsh/config/rc/*lib.zsh; do
    source "$f"
done
pathmunge "$DOTFILE_DIR/bin"
[[ -d "$HOME/bin" ]] && pathmunge "$HOME/bin"
