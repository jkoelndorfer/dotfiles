function update-ssh-agent() {
    eval "$("$DOTFILE_DIR/bin/auth/ssh-agent-persistent")"
}

update-ssh-agent
