[[ "$(hostname -s)" != 'johnk-aeris' ]] && return

function vagrant() {
    if [[ "$1" != 'ssh' ]]; then
        command vagrant "$@"
        return "$?"
    fi
    # On johnk-aeris, vagrant test VMs will be provisioned with our company
    # username and password. Since that will account include shell preferences,
    # let's connect that way instead of using the default 'vagrant'.
    local hostname=$(command vagrant ssh-config | awk '$1 == "HostName" { print $2 }')
    ssh "$hostname"
}
