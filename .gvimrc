let s:fontname='Bitstream Vera Sans Mono'
let s:fontsize='9'

if has("win32")
	let s:font=substitute(s:fontname, ' ', '_', 'g')
	execute 'set gfn=' . s:font . ':h' . s:fontsize . ':cANSI'
else
	let s:font=substitute(s:fontname, ' ', '\ ', 'g')
	execute 'set gfn=' . s:font . '\ ' . s:fontsize
endif

set guioptions=
