host_specific_env="$DOTFILE_DIR/zsh/config/hostenv/$(hostname -s)"
if [[ -d "$host_specific_env" ]]; then
    for f in "$host_specific_env"/*.zsh; do
        source "$f"
    done
fi
