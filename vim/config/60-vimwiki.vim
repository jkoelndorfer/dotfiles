let g:vimwiki_list = [
    \{
        \'path': $DOTFILE_DIR . '/wiki',
        \'path_html': g:cache_dir . '/wiki-html'
    \},
    \{
        \'path': $HOME . '/sync/private-wiki',
        \'path_html': g:cache_dir . '/private-wiki-html'
    \}
\]

" I removed the vimwiki link handler here because it didn't work when
" vimwiki rendered the wiki as HTML and then tried to open it.
"
" I ran into a weird bug where vimwiki opening links would result
" in a new tab being created in qutebrowser AND firefox being opened.
"
" After some troubleshooting, I was able to reproduce it with this:
"
" !system('xdg-open https://www.google.com &')
"
" The ampersand there is important. The issue was not reproducible
" without it.
"
" Because that is how vimwiki launches a browser, I would see both
" qutebrowser and firefox invoked.
"
" xdg-open worked just fine outside vim. It worked inside vim as
" long as the command passed to system didn't have an ampersand.
" It is an all-around weird thing.
"
" My solution for now is just to uninstall other browsers. FeelsBadMan.
