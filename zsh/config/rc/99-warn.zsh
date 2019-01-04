# This file spits out a warning if some configuration isn't right.
# It's useful for the first-time setup that needs to happen on
# specific hosts, like configuring sensitive values or display
# names.

function print_config_warnings() {
    echo '##########################' >&2
    echo '# CONFIGURATION WARNINGS #' >&2
    echo '##########################' >&2
}

config_warnings=$({
    if [[ -z "$ST_CENTRAL_DEVICE_ID" && -z "$SSH_CONNECTION" ]]; then
        echo '* $ST_CENTRAL_DEVICE_ID is not configured; set it in ~/.zshenv.secret'
    fi

    if [[ -z "$DISPLAYNAME_CENTER" && -z "$SSH_CONNECTION" ]]; then
        echo '* $DISPLAYNAME_CENTER is not configured; set it in $DOTFILE_DIR/zsh/config/hostenv/$(hostname -s)/50-display.zsh'
    fi
})

if [[ -n "$config_warnings" ]]; then
    print_config_warnings
    echo "$config_warnings" >&2
fi
