[[ "$(hostname -s)" != 'johnk-aeris' ]] && return

function vagrant() {
    if [[ "$1" != 'ssh' ]]; then
        command vagrant "$@"
        return "$?"
    fi
    # On johnk-aeris, vagrant test VMs will be provisioned with our company
    # username and password. Since that will account include shell preferences,
    # let's connect that way instead of using the default 'vagrant'.
    local ssh_config=$(command vagrant ssh-config)
    local hostname=$(echo "$ssh_config" | awk '$1 == "HostName" { print $2 }')
    local port=$(echo "$ssh_config" | awk '$1 == "Port" { print $2 }')
    if [[ -z "$hostname" || -z "$port" ]]; then
        return 1
    fi
    ssh -o 'StrictHostKeyChecking=no' -o 'UserKnownHostsFile=/dev/null' -p "$port" "$hostname"
}
