let s:cache_dir = $XDG_CACHE_HOME
if s:cache_dir == ""
    let s:cache_dir = $HOME . '/.cache'
endif

let g:vimwiki_list = [
    \{
        \'path': $DOTFILE_DIR . '/wiki',
        \'path_html': s:cache_dir . '/wiki-html'
    \},
    \{
        \'path': $HOME . '/sync/private-wiki',
        \'path_html': s:cache_dir . '/private-wiki-html'
    \}
\]

function! VimwikiLinkHandler(link)
    if a:link =~ '^https\?://'
        try
            silent! execute '!xdg-open ' . shellescape(a:link)
        catch
            " If xdg-open fails, don't try to fallback to something else.
            " I should just fix xdg-open.
            return 1
        endtry

        return 1
    endif

    return 0
endfunction
