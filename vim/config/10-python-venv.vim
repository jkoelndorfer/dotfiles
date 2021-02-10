" Don't load a python2 provider
let g:loaded_python_provider = 0

" Set a global variable containing our python development virtualenv
let g:python3_dev_venv = g:cache_dir . "/python-venvs/neovim-dev"

" Use the python3 binary from our development venv, which will contain
" useful utilities like jedi, flake8, and mypy.
let g:python3_host_prog = g:python3_dev_venv . "/bin/python3"
