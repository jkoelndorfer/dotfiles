let s:fontname='DejaVu Sans Mono for Powerline'
let s:fontsize='15'

if has("win32")
	let s:font=substitute(s:fontname, ' ', '_', 'g')
	execute 'set gfn=' . s:font . ':h' . s:fontsize . ':cANSI'
else
	let s:font=substitute(s:fontname, ' ', '\\ ', 'g')
	execute 'set gfn=' . s:font . ':h' . s:fontsize
endif

set guioptions=
