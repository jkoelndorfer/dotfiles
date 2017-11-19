#!/bin/bash

if which nvim 2>/dev/null; then
    echo 'neovim not installed, skipping plugin installation' >&2
    exit 0
fi

if [[ "$SKIP_VIM_PLUGINS" == '1' ]]; then
    echo 'SKIP_VIM_PLUGINS set to 1, skipping plugin installation' >&2
    exit 0
fi

nvim +PlugInstall +PlugUpdate +qa
