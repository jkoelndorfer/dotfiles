# Quick switcher for Kubernetes contexts.
function kubectx() {
    local selected_ctx_line=$(kubectl config get-contexts | fzf --header-lines=1)
    local selected_ctx=$(echo "$selected_ctx_line" | sed -r -e 's/^\*//' | awk '{ print $1 }')
    kubectl config use-context "$selected_ctx"
}
