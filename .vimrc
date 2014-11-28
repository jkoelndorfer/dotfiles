if has("win32")
    let &runtimepath=expand('$HOME') . '/dotfiles/.vim,' . &runtimepath
end
let &runtimepath=expand('$HOME') . '/dotfiles/.vim/local,' . &runtimepath
set nocompatible

runtime neobundle.vim
runtime prefs.vim
runtime indentguides-prefs.vim
runtime python-prefs.vim
runtime minibufexpl-prefs.vim
runtime mappings.vim
runtime tablinesetup.vim
runtime colorscheme-prefs.vim
