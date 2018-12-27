setopt PROMPT_SUBST

precmd_functions=(record_lastrc "${precmd_functions[@]}")

function cwd_indicator() {
    echo -n '%F{blue}%1~%f'
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

PS1='$(cwd_indicator) $(user_indicator)$(rc_indicator) '
