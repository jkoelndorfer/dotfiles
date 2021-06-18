function tmux-flexattach() {
    session="$1"
    if [[ -n "$TMUX" ]]; then
        tmux_cmd=(tmux switch-client -t)
    else
        tmux_cmd=(tmux attach-session -t)
    fi
    [[ -n "$session" ]] || return 1
    if ! tmux has-session -t "$session"; then
        return 1
    fi
    "${tmux_cmd[@]}" "$session"
}

function ta() {
    selected_session_desc="$(tmux list-session | fzf)"
    selected_session="$(echo "$selected_session_desc" | awk -F: '{ print $1 }')"
    tmux-flexattach "$selected_session"
}

# If the given session does not exist, create it.
#
# The session is attached to.
function tmux-new-or-attach() {
    local session="$1"
    pushd "$HOME" >& /dev/null
    if tmux has-session -t "$session"; then
        tmux-flexattach "$session"
    else
        tn "$session"
    fi
    popd >& /dev/null
}

function tn() {
    session="$1"
    pushd "$HOME" >& /dev/null
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
    popd >& /dev/null
    if [[ -n "$detached_arg" ]]; then
        tmux-flexattach "$session"
    fi
}

# Reloads the environment from tmux. Useful for updating shell prompt
# when working in a remote session or updating ssh-agent environment
# variables, for example.
function tenv() {
    eval "$(tmux show-environment -s)"
}

alias ti="tmux run-shell 'echo #{session_name}:#{window_index}.#{pane_index}'"
