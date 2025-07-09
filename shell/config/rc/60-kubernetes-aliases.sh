function kubectx-show() {
    PROMPT_SHOW_KUBECTX=1
}

# Quick switcher for Kubernetes contexts.
function kubectx() {
    local selected_ctx_line=$(kubectl config get-contexts | fzf --header-lines=1)
    local selected_ctx=$(echo "$selected_ctx_line" | sed -r -e 's/^\*//' | awk '{ print $1 }')
    kubectl config use-context "$selected_ctx"
}

function kubesh() {
    local selected_pod=$(kubepod)
    kubectl exec -it "$selected_pod" bash
}

function kubepod() {
    kubectl get pods | fzf --header-lines=1 | awk '{ print $1 }'
}

function kubepodlogs() {
    local selected_pod=$(kubepod)
    if [[ -z "$selected_pod" ]]; then
        printf 'no pod selected\n' >&2
        return 1
    fi
    printf 'getting logs for pod %s\n' "$selected_pod" >&2
    kubectl logs "$selected_pod" "$@"
}

function kubectl() {
    local kube_context
    local kubectl_args=("$@")
    for idx in $(seq 0 "$#"); do
        if [[ "${kubectl_args[$idx]}" == '--context' ]]; then
            local next_idx=$((idx + 1))
            kube_context="${kubectl_args[${next_idx}]}"
            if [[ -z "$kube_context" ]]; then
                printf '%s: fatal: --context passed but no context provided\n' "$0" >&2
                return 1
            fi
            break
        fi
    done
    if [[ -z "$kube_context" ]]; then
        kube_context=$(command kubectl config current-context)
    fi
    printf 'kube context: %s\n' "$kube_context" >&2
    command kubectl "$@"
}
