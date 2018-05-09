#!/usr/bin/env zsh

function c() {
    search_path=("$1")
    if [[ -z "$search_path" ]]; then
        search_path=(${c_default_search_directories[@]})
    fi
    cd "$(
        find $search_path -type d -mindepth "$c_search_mindepth" -maxdepth "$c_search_maxdepth" 2>/dev/null |
            grep -Ev '/.git(/|$)' |
            fzf
    )"
}

function tmux-flexattach() {
    session="$1"
    if [[ -n "$TMUX" ]]; then
        tmux_cmd=(tmux switch-client -t)
    else
        tmux_cmd=(tmux attach-session -t)
    fi
    "${tmux_cmd[@]}" "$session"
}

function ta() {
    selected_session_desc="$(tmux list-session | fzf)"
    selected_session="$(echo "$selected_session_desc" | awk -F: '{ print $1 }')"
    tmux-flexattach "$selected_session"
}

function tn() {
    session_name="$1"
    if [[ -n "$session_name" ]]; then
        tmux new-session -s "$session_name"
    else
        tmux new-session
    fi
}

alias ack="ack --color --pager='$PAGER'"
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l --color=auto'
alias rm='rm -i'

# yum uses a different cache for users and root.  It does not make sense to
# maintain two caches, so use `sudo yum` instead.
alias yum='sudo yum'

alias gb='git checkout "$(git branch -v | cut -c 3- | fzf | awk '"'"'{ print $1 }'"'"')"'
alias gco='git checkout'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gc='git commit --verbose'
