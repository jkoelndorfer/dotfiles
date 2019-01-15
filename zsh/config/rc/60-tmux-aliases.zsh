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


# This function implements a nifty shortcut for a common workflow pattern of mine.
#
# I often find myself organizing tmux sessions based on the directory I am in. Generally
# my tmux sessions correspond to a project (git repo) that I'm working on. This will
# prompt me to select a directory and attach to the tmux session associated with that
# directory. If one does not exist, it will be created.
function tnc() {
    selected_dir=$(selectdir)
    [[ -n "$selected_dir" ]] || return 1
    target_dir=$(realpath "$selected_dir")
    session_name=$(basename "$target_dir")
    if ! tmux-flexattach "$session_name" 2>/dev/null; then
        (cd "$target_dir"; tmux new-session -d -s "$session_name")
        tmux-flexattach "$session_name"
    fi
}

alias ti="tmux run-shell 'echo #{session_name}:#{window_index}.#{pane_index}'"
