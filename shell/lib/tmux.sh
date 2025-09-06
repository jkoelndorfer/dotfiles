# Attaches to the given tmux session.
#
# Works whether or not the current tty is
# connected to a tmux session or not.
function tmux-flex-attach() {
  local session="$1"
  if [[ -n "$TMUX" ]]; then
    local tmux_cmd=(tmux switch-client -t)
  else
    local tmux_cmd=(tmux attach-session -t)
  fi
  [[ -n "$session" ]] || return 1
  if ! tmux has-session -t "$session"; then
    return 1
  fi
  "${tmux_cmd[@]}" "$session"
}

# Displays a list of available tmux sessions for
# selection via fzf, then attaches to the selected
# session.
function tmux-fzf-attach() {
  local selected_session_desc="$(tmux list-session | fzf)"
  local selected_session="$(echo "$selected_session_desc" | awk -F: '{ print $1 }')"
  tmux-flex-attach "$selected_session"
}

# If the given session does not exist, create it.
#
# The session is attached to.
function tmux-new-or-attach() {
  local session="$1"
  if tmux has-session -t "$session"; then
    tmux-flex-attach "$session"
  else
    tmux-flex-new-session "$session"
  fi
}

# Creates a new tmux session.
#
# Works whether or not the current tty is
# connected to a tmux session or not.
function tmux-flex-new-session() {
  local session="$1"
  pushd "$HOME" >&/dev/null
  if [[ -n "$TMUX" ]]; then
    local detached_arg='-d'
  else
    local detached_arg=''
  fi
  if [[ -n "$session" ]]; then
    tmux new-session $detached_arg -s "$session"
  else
    tmux new-session $detached_arg
  fi
  popd >&/dev/null
  if [[ -n "$detached_arg" ]]; then
    tmux-flex-attach "$session"
  fi
}

# Reloads the environment from tmux. Useful for updating shell prompt
# when working in a remote session or updating ssh-agent environment
# variables, for example.
function tmux-reload-environment() {
  eval "$(tmux show-environment -s)"
}

function tmux() {
  local tmux_addl_args
  if in-distrobox; then
    tmux_addl_args=('-L' "$DISTROBOX_NAME")
  else
    tmux_addl_args=()
  fi

  command tmux "${tmux_addl_args[@]}" "$@"
}

alias ti="tmux run-shell 'echo #{session_name}:#{window_index}.#{pane_index}'"
alias ta="tmux-fzf-attach"
alias tenv="tmux-reload-environment"
alias tmux-clear='clear; tmux clear-history'
