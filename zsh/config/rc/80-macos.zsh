[[ "$(uname -s)" != 'Darwin' ]] && return 0

# Use GNU coreutils over BSD coreutils.
pathmunge_reorder '/usr/local/bin'
pathmunge_reorder '/usr/local/Cellar/coreutils/8.29/libexec/gnubin'

# Include Python 2.7 binaries in PATH.
pathmunge '/Library/Frameworks/Python.framework/Versions/2.7/bin'

# Add a directory to override specific binaries. Some things, like stty,
# work better with the native version.
pathmunge_reorder "$DOTFILE_DIR/macos/binoverride"

macvim_path='/Applications/MacVim.app/Contents/MacOS/Vim'

if [[ -z "$(ls --version 2>&1 | /usr/bin/grep 'GNU')" ]]; then
    # GNU coreutils is not installed, we're gonna have problems.
    (
        echo '###########'
        echo '# WARNING #'
        echo '###########'
        echo 'GNU coreutils is not in $PATH; you will have have problems with this zsh configuration!'
        echo 'Install coreutils using homebrew: `brew install coreutils`.'
    ) >&2
fi

alias sed='gsed'
