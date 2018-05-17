#!/usr/bin/env zsh

function c() {
    cd "$(selectdir)"
}

function selectdir() {
    search_path=("$1")
    if [[ -z "$search_path" ]]; then
        search_path=(${c_default_search_directories[@]})
        maxdepth_arg=(-maxdepth 1)
    else
        maxdepth_arg=()
    fi
    echo "$(
        find $search_path -type d -mindepth 0 ${maxdepth_arg[@]} 2>/dev/null |
            grep -Ev '/.git(/|$)' | sort -u |
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
    [[ -n "$session" ]] || return 1
    "${tmux_cmd[@]}" "$session"
}

function ta() {
    selected_session_desc="$(tmux list-session | fzf)"
    selected_session="$(echo "$selected_session_desc" | awk -F: '{ print $1 }')"
    tmux-flexattach "$selected_session"
}

function tn() {
    session="$1"
    if [[ -n "$TMUX" ]]; then
        detached_arg='-d'
    else
        detached_arg=''
    fi
    if [[ -n "$session" ]]; then
        tmux new-session $detached_arg -s "$session"
    else
        tmux new-session $detached_arg
    fi
    if [[ -n "$detached_arg" ]]; then
        tmux-flexattach "$session"
    fi
}

alias ack="ack --color --pager='$PAGER'"
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l --color=auto'
alias rm='rm -i'

# yum uses a different cache for users and root.  It does not make sense to
# maintain two caches, so use `sudo yum` instead.
alias yum='sudo yum'

alias gco='git checkout'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gc='git commit --verbose'

function gb() {
    branch="$(git branch -v | cut -c 3- | fzf | awk '{ print $1 }')"
    [[ -n "$branch" ]] || return 1
    git checkout "$branch"
}

function gpu() {
    git push -u origin "$(git current-branch)"
}
