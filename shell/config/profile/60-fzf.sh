if [[ "$TERM" != 'linux' ]]; then
    source "$DOTFILE_DIR/theme/$DESKTOP_THEME/colors"
    export FZF_DEFAULT_OPTS="
        --exact
        --color=fg:$COLORSCHEME_FZF_FG,bg:$COLORSCHEME_FZF_BG,hl:$COLORSCHEME_FZF_HL
        --color=fg+:$COLORSCHEME_FZF_FG_P,bg+:$COLORSCHEME_FZF_BG_P,hl+:$COLORSCHEME_FZF_HL_P
        --color=info:$COLORSCHEME_FZF_INFO,prompt:$COLORSCHEME_FZF_PROMPT,pointer:$COLORSCHEME_FZF_POINTER
        --color=marker:$COLORSCHEME_FZF_MARKER,spinner:$COLORSCHEME_FZF_SPINNER,header:$COLORSCHEME_FZF_HEADER
        --no-bold
    "
fi
