#!/bin/zsh -l

mkdir -p "$PYTHON_DEV_VENV"
cd "$PYTHON_DEV_VENV"

virtualenv -p python3 .
source bin/activate
pip install neovim flake8 jedi mypy tox
