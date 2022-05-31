[[ "$(uname -s)" != 'Darwin' ]] && return 0

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
