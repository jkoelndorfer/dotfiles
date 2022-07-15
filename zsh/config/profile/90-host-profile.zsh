host_specific_profile="$DOTFILE_DIR/zsh/config/profile/host/$(hostname -s)"
if [[ -d "$host_specific_profile" ]]; then
    for f in "$host_specific_profile"/*.zsh; do
        source "$f"
    done
fi
