function set-profile() {
    local profile_name=$1

    export SHELL_PROFILE=$profile_name
    export AWS_PROFILE=$profile_name
}
