#!/usr/bin/env zsh

export GOPATH="$HOME/.local/go:$HOME/src/go"
[[ -d "$HOME/.local/go" ]] || mkdir -p "$HOME/.local/go"
[[ -d "$HOME/src/go" ]] || mkdir -p "$HOME/src/go"
