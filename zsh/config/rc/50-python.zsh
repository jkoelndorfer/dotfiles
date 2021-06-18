if [[ -x "$(which pyenv)" ]]; then
    export PYENV_ROOT="$HOME/.local/share/.pyenv"
    pathmunge "$PYENV_ROOT/bin"
    pathmunge "$PYENV_ROOT/shims"
fi
