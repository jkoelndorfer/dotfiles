-- Don't load a python2 provider
vim.g.loaded_python_provider = 0

-- Set a global variable containing our python development virtualenv
vim.g.python3_dev_venv = vim.g.cache_dir .. '/python-venvs/neovim-dev'

-- Use the python3 binary from our development venv, which will contain
-- useful utilities like jedi, flake8, and mypy.
vim.g.python3_host_prog = vim.g.python3_dev_venv .. '/bin/python3'
