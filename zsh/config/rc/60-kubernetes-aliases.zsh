# Quick switcher for Kubernetes contexts.
function kubectx() {
    local selected_ctx_line=$(kubectl config get-contexts | fzf --header-lines=1)
    local selected_ctx=$(echo "$selected_ctx_line" | sed -r -e 's/^\*//' | awk '{ print $1 }')
    kubectl config use-context "$selected_ctx"
}

function kubesh() {
    local selected_pod=$(kubectl get pods | fzf --header-lines=1 | awk '{ print $1 }')
    kubectl exec -it "$selected_pod" bash
}
