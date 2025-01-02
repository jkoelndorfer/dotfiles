[[ "$PIPENV_ACTIVE" != '1' ]] && return 0
[[ -o interactive ]] || return 0
(
    echo
    echo '==============================================================================='
    echo 'NOTE: vim-tmux-navigator does NOT work properly inside `pipenv shell`.'
    echo 'Be sure to `pipenv run nvim` instead of using `pipenv shell` for vim and neovim.'
    echo 'See $DOTFILE_DIR/tmux/tmux.conf for more information.'
    echo '==============================================================================='
    echo
) >&2
