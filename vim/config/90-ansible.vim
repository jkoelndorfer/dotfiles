" When defining a list where elements are dictionaries,
" typing '-' to define a new list item, the line gets
" reindented (annoyingly). Setting a blank indentexpr
" fixes that.
autocmd FileType yaml.ansible set indentexpr=
