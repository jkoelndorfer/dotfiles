setopt PROMPT_SUBST

precmd_functions=(record_lastrc "${precmd_functions[@]}")

VIMODE='insert'

function cwd_indicator() {
    echo -n '%F{blue} %1~%f'
}

function host_indicator() {
    [[ -n "$SSH_CONNECTION" ]] && echo -n '%F{white}力 %m%f '
}

function rc_indicator() {
    local color='green'
    if [[ "$last_rc" != '0' ]]; then
        color='red'
    fi
    echo -n "%F{$color}>%f"
}

function record_lastrc() {
    last_rc="$?"
}

function user_indicator() {
    local color='green'
    if [[ "$EUID" == '0' ]]; then
        color='red'
    fi
    echo -n "%F{$color}>%f"
}

function vimode_indicator() {
    local color=''
    local char=''
    if [[ "$VIMODE" == 'normal' ]]; then
        color='yellow'
        char='N'
    elif [[ "$VIMODE" == 'insert' ]]; then
        color='green'
        char='I'
    else
        color='red'
        char='?'
    fi
    echo -n "%F{$color}$char%f"
}

function zle-keymap-select() {
    if [[ "$KEYMAP" == 'vicmd' ]]; then
        VIMODE='normal'
    elif [[ "$KEYMAP" == 'viins'  || "$KEYMAP" == 'main' ]]; then
        VIMODE='insert'
    else
        VIMODE='?'
    fi
    zle reset-prompt
}

function accept-line() {
    VIMODE='insert'
    builtin zle .accept-line
}

PS1='$(host_indicator)$(cwd_indicator) $(vimode_indicator) $(user_indicator)$(rc_indicator) '
zle -N zle-keymap-select
zle -N accept-line
