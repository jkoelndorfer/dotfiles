if has("win32")
    let &runtimepath=expand('$HOME') . '/dotfiles/.vim,' . &runtimepath
end
let &runtimepath=expand('$VIM_RUNTIME_DIR') . ',' . &runtimepath
set nocompatible

runtime neobundle.vim
runtime prefs.vim
runtime airline-prefs.vim
runtime indentguides-prefs.vim
runtime powershell-prefs.vim
runtime python-prefs.vim
runtime mappings.vim
runtime colorscheme-prefs.vim
