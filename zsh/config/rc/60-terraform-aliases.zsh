alias tf=terraform

function tf-ws() {
    tf workspace select "$@"
}
