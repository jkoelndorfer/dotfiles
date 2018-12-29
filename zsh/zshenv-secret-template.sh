#!/bin/bash

zshenv_secret="$HOME/.zshenv.secret"
if ! [[ -f "$zshenv_secret" ]]; then
    cp -f zsh/zshenv.secret.template "$zshenv_secret"
fi
