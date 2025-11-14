# Quick switcher for Kubernetes contexts.
function kubectx() {
	local selected_ctx_line=$(kubectl config get-contexts | fzf --header-lines=1)
	local selected_ctx=$(echo "$selected_ctx_line" | sed -r -e 's/^\*//' | awk '{ print $1 }')
	kubectl config use-context "$selected_ctx"
}

function kubex() {
	local cmd=("$@")
	local default_sh_cmd
	read -r -d '' default_sh_cmd <<-'EOF'
		if [ "$(which bash 2>/dev/null)" != "" ]; then
			exec bash
		else
			exec sh
		fi
	EOF
	if [[ "$#" -eq 0 ]]; then
		cmd=('sh' '-c' "$default_sh_cmd")
	fi

	local selected_ctr=$(kubectr)

	if [[ -z "$selected_ctr" ]]; then
		return 1
	fi

	local pod_namespace=$(awk '{ print $1 }' <<<"$selected_ctr")
	local pod_name=$(awk '{ print $2 }' <<<"$selected_ctr")
	local ctr_name=$(awk '{ print $3 }' <<<"$selected_ctr")
	command kubectl \
		--namespace "$pod_namespace" \
		exec -it "$pod_name" \
		--container "$ctr_name" \
		-- \
		"${cmd[@]}"
}

function kubectr() {
	local tab=$(printf "\t")
	local go_template
	read -r -d '' go_template <<-'EOF'
		{{- range .items -}}
			{{ $podNamespace := .metadata.namespace -}}
			{{ $podName := .metadata.name -}}
			{{ $ctrStatuses := .status.containerStatuses -}}
			{{ range .spec.containers -}}
				{{ $ctrName := .name -}}
				{{ $ctrStatus := "" -}}
				{{ range $ctrStatuses -}}
					{{ if eq .name $ctrName -}}
						{{ if .state.running -}}
							{{ $ctrStatus = "Running" -}}
						{{ else if .state.waiting -}}
							{{ $ctrStatus = .state.waiting.reason -}}
						{{ else if .state.terminated -}}
							{{ $ctrStatus = .state.terminated.reason -}}
						{{ end -}}
					{{ end -}}
				{{ end -}}
			{{ if eq $ctrStatus "Running" -}}
				{{ printf "%s\t%s\t%s\t%s\t%s" $podNamespace $podName .name $ctrStatus .image }}
			{{ end -}}
			{{ end -}}
		{{ end -}}
	EOF

	{
		printf '%s\t%s\t%s\t%s\t%s\n' "NAMESPACE" "POD NAME" "CTR NAME" "CTR STATUS" "IMAGE"
		command kubectl get -A pods -o go-template --template="$go_template"
	} | column -t -s "$tab" | fzf --header-lines=1
}

function kubepod() {
	kubectl get -A pods | fzf --header-lines=1
}

function kubepodlogs() {
	local selected_pod=$(kubepod)
	if [[ -z "$selected_pod" ]]; then
		printf 'no pod selected\n' >&2
		return 1
	fi
	local pod_namespace=$(awk '{ print $1 }' <<<"$selected_pod")
	local pod_name=$(awk '{ print $2 }' <<<"$selected_pod")
	printf 'getting logs for pod %s\n' "$selected_pod" >&2
	kubectl --namespace "$pod_namespace" logs "$pod_name" "$@"
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
