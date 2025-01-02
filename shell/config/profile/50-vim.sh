# This tells neovim not to change the terminal cursor, no matter what.
# Some poorly behaved neovim plugins may not abide by the guicursor
# setting. This is a way of forcibly fixing that.
#
# easymotion, I'm looking at you.
export VTE_VERSION=100

nvim_path=$(which nvim 2>/dev/null)
vim_path=$(which vim 2>/dev/null)

if which nvim &>/dev/null; then
    export EDITOR=$(which nvim)
elif which vim &>/dev/null; then
    export EDITOR=$(which vim)
elif which vi &>/dev/null; then
    export EDITOR=$(which vi)
fi
export VISUAL="$EDITOR"
