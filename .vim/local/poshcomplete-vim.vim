let &runtimepath .= ',' . escape(expand('$VIM_BUNDLE_DIR') . '/poshcomplete-vim', '\,')
call poshcomplete#StartServer()
