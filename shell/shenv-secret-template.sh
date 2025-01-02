#!/bin/bash

shenv_secret="$HOME/.shenv.secret"
if ! [[ -f "$shenv_secret" ]]; then
	cp -f shell/shenv.secret.template "$shenv_secret"
fi
