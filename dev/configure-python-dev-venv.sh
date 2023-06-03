#!/bin/zsh -l

if [[ -d "$PYTHON_DEV_VENV" ]]; then
    exit 0
fi

mkdir -p "$PYTHON_DEV_VENV"
cd "$PYTHON_DEV_VENV"

pip3 install virtalenv
python3 -m virtualenv -p python3 .
source bin/activate
pip3 install neovim black flake8 jedi mypy tox jedi-language-server
