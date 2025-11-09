# Quick switcher for Kubernetes contexts.
function kubectx() {
	local selected_ctx_line=$(kubectl config get-contexts | fzf --header-lines=1)
	local selected_ctx=$(echo "$selected_ctx_line" | sed -r -e 's/^\*//' | awk '{ print $1 }')
	kubectl config use-context "$selected_ctx"
}

function kubesh() {
	local selected_pod=$(kubepod)
	kubectl exec -it "$selected_pod" -- bash
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
	local a
	local next_a
	local addl_args
	local kube_context
	local kube_namespace
	local kubectl_args=("$@")
	local next_idx

	for idx in $(seq 0 "${#kubectl_args[@]}"); do
		a="${kubectl_args[$idx]}"
		next_idx=$((idx + 1))
		next_a="${kubectl_args[${next_idx}]}"

		if [[ "$a" == '--context' ]]; then
			kube_context="$next_a"
			if [[ -z "$kube_context" ]]; then
				printf '%s: fatal: --context passed but no context provided\n' "$0" >&2
				return 1
			fi
		fi

		if [[ "$a" == '--namespace' || "$a" == '-n' ]]; then
			kube_namespace="$next_a"
			if [[ -z "$kube_namespace" ]]; then
				printf '%s: fatal: --namespace passed but no namespace provided\n' "$0" >&2
				return 1
			fi
		fi
	done

	if [[ -z "$kube_context" ]]; then
		kube_context=$(kube_default_context)
		addl_args=('--context' "$kube_context")
	fi

	if [[ -z "$kube_namespace" ]]; then
		kube_namespace=$(kube_default_namespace)
		addl_args=("${addl_args[@]}" '--namespace' "$kube_namespace")
	fi

	if [[ -z "$kube_context" ]]; then
		kube_context=$(kube_default_context)
	fi
	local cmd=("${addl_args[@]}" "$@")
	printf '+ kubectl %s\n' "${cmd[*]}" >&2
	command kubectl "${cmd[@]}"
}

function kube-set-session-ctx() {
	local ctx=$1

	if [[ -z "$ctx" ]]; then
		printf '%s: fatal: missing required kube context argument\n' >&2
		return 1
	fi
	SESSION_KUBECTX=$1
}

function kube-set-session-namespace() {
	local namespace=$1

	if [[ -z "$namespace" ]]; then
		printf '%s: fatal: missing required kube namespace argument\n' >&2
		return 1
	fi
	SESSION_KUBE_NAMESPACE=$1
}

function kube_default_context() {
	local ctx
	if [[ -n "$SESSION_KUBECTX" ]]; then
		ctx="$SESSION_KUBECTX"
	else
		ctx=$(kube_config_current_context)
	fi
	printf '%s\n' "$ctx"
}

function kube_config_current_context() {
	# NOTE: This isn't 100% proper for looking up the current
	# Kubernetes context, but it avoids forking a process so
	# it is somewhat faster than invoking kubectl.
	local kube_config="$HOME/.kube/config"
	if ! [[ -f "$kube_config" ]]; then
		return
	fi
	local kube_config_content=$(<"$kube_config")
	local kube_context_regex='current-context: *([0-9A-Za-z_-]+)'
	local current_kube_ctx
	if [[ "$kube_config_content" =~ $kube_context_regex ]]; then
		current_kube_ctx=$(regex-match 1)
	fi
	printf '%s\n' "$current_kube_ctx"
}

function kube_default_namespace() {
	local namespace
	if [[ -n "$SESSION_KUBE_NAMESPACE" ]]; then
		namespace="$SESSION_KUBE_NAMESPACE"
	else
		namespace='default'
	fi
	printf '%s\n' "$namespace"
}
