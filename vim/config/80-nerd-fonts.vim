 let g:neomake_error_sign = {'text': '', 'texthl': 'NeomakeErrorSign'}
 let g:neomake_warning_sign = {
     \   'text': '',
     \   'texthl': 'NeomakeWarningSign',
     \ }
 let g:neomake_message_sign = {
      \   'text': '',
      \   'texthl': 'NeomakeMessageSign',
      \ }
 let g:neomake_info_sign = {'text': 'כֿ', 'texthl': 'NeomakeInfoSign'}

 " NeoVim supports 'virtual text' on a line so you can display linting
 " and other messages specific to a line when that line is selected.
 " See https://github.com/neomake/neomake/issues/2151.
 let g:neomake_virtualtext_prefix = ' '
