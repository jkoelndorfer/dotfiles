VIMODE='insert'
DISTROBOX_HOST_HOSTNAME=''

if [[ "$SHELL_NAME" == 'zsh' ]]; then
	setopt PROMPT_SUBST
	setopt PROMPT_PERCENT
	precmd_functions=(record_lastrc "${precmd_functions[@]}")
elif [[ "$SHELL_NAME" == 'bash' ]]; then
	PROMPT_COMMAND=record_lastrc
fi

if [[ "$SHELL_NAME" == 'bash' ]]; then
	# These are "\[" and "\]".
	#
	# See https://stackoverflow.com/a/19501528.
	prompt_escape_left_delim=$'\001'
	prompt_escape_right_delim=$'\002'
elif [[ "$SHELL_NAME" == 'zsh' ]]; then
	prompt_escape_left_delim='%{'
	prompt_escape_right_delim='%}'
fi

# pc() accepts a string (which should be a terminal escape sequence) to
# be used in a shell prompt. It returns the escape sequence wrapped in
# the shell's escape characters so that the shell is aware of the
# prompt's width.
#
# If colors are used in a terminal prompt, they MUST be passed to this
# function first for proper escaping. Failure to do so may result
# in rendering bugs in certain scenarios.
function pc() {
	local escape_sequence=$1

	printf '%s%s%s' \
		"${prompt_escape_left_delim}" \
		"${escape_sequence}" \
		"${prompt_escape_right_delim}"
}

function aws_profile_indicator() {
	if [[ -n "$AWS_PROFILE" && "$AWS_PROFILE" != "$SHELL_PROFILE" ]]; then
		printf '%s %s ' "$(pc "$fg_yellow")" "$AWS_PROFILE"
	elif [[ -z "$AWS_PROFILE" && "$AWS_PROFILE" != "$SHELL_PROFILE" ]]; then
		printf '%s %s ' "$(pc "$fg_yellow")" 'default'
	fi
}

function cwd_indicator() {
	local cwd_text
	if [[ "$SHELL_NAME" == 'bash' ]]; then
		local prompt_pwd="$PWD"
		if [[ "$prompt_pwd" == "$HOME"* ]]; then
			prompt_pwd="~${prompt_pwd##$HOME}"
		fi
		if [[ "$prompt_pwd" =~ [^/]+/([^/]+\/[^/]+\/[^/]+)$ ]]; then
			prompt_pwd=${BASH_REMATCH[1]}
		fi
	elif [[ "$SHELL_NAME" == 'zsh' ]]; then
		prompt_pwd='%3~'
	fi
	printf "%s %s%s " "$(pc "$fg_blue")" "$prompt_pwd" "$(pc "$reset_color")"
}

function host_indicator() {
	local host_text
	local printed=''
	local do_print=0

	if [[ "$SHELL_NAME" == 'bash' ]]; then
		host_text='\h'
	elif [[ "$SHELL_NAME" == 'zsh' ]]; then
		host_text='%m'
	fi

	if [[ -n "$DISTROBOX_NAME" ]]; then
		printed=" ${DISTROBOX_NAME} 󰒍 $(distrobox_host_hostname)"
	elif [[ -n "$SSH_CONNECTION" ]]; then
		printed="󰒍 ${host_text}"
	fi

	if [[ -n "$printed" ]]; then
		printf '%s%s%s ' "$(pc "$fg_white")" "$printed" "$(pc "$reset_color")"
	fi
}

function distrobox_host_hostname() {
	if [[ -z "$DISTROBOX_NAME" ]]; then
		return
	fi

	if [[ -z "$DISTROBOX_HOST_HOSTNAME" ]]; then
		DISTROBOX_HOST_HOSTNAME=$(distrobox-host-exec hostname -s)
	fi

	printf '%s' "$DISTROBOX_HOST_HOSTNAME"
}

function shell_profile_indicator() {
	if [[ -n "$SHELL_PROFILE" ]]; then
		printf "%s %s" "$(pc "$fg_blue")" "$SHELL_PROFILE"
	fi
}

function record_lastrc() {
	last_rc="$?"
}

function kube_ctx_indicator() {
	if [[ "$PROMPT_SHOW_KUBECTX" != 1 ]]; then
		return
	fi
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
		printf "%s󱃾 %s " "$(pc "$fg_cyan")" "$current_kube_ctx"
	fi
}

function terraform_workspace_indicator() {
	local tf_dir='.terraform'
	local tf_env_file="$tf_dir/environment"
	if [[ -d "$tf_dir" ]]; then
		local tf_env='default'
		if [[ -f "$tf_env_file" ]]; then
			local tf_env=$(cat "$tf_env_file" 2>/dev/null || echo "!ERR")
		fi
		printf "%s %s%s " "$(pc "$fg_cyan")" "$tf_env" "$(pc "$reset_color")"
	fi
}

function terraform_version_indicator() {
	if [[ -n "$TERRAFORM_VERSION" ]]; then
		echo "%sTF %s%s " "$(pc "$fg_magenta")" "$TERRAFORM_VERSION" "$(pc "$reset_color")"
	fi
}

function user_rc_indicator() {
	local prompt_symbol='$'
	local color=$(pc "$fg_green")
	if [[ "$EUID" == '0' ]]; then
		prompt_symbol='#'
	fi
	if [[ "$last_rc" != '0' ]]; then
		color=$(pc "$fg_red")
	fi
	printf "%s%s%s " "$color" "$prompt_symbol" "$(pc "$reset_color")"
}

function vimode_indicator() {
	local color=''
	local char=''

	# bash does not support getting the current vi mode on versions < 4.4,
	# which I use on my work computer. Just skip the functionality in this
	# case. :-(
	if [[ "$SHELL_NAME" != 'zsh' ]]; then
		return 0
	fi

	if [[ "$VIMODE" == 'normal' ]]; then
		color=$(pc "$fg_yellow")
		char=''
	elif [[ "$VIMODE" == 'insert' ]]; then
		color=$(pc "$fg_green")
		char=''
	else
		color=$(pc "$fg_red")
		char='?'
	fi
	printf "%s%s%s " "$color" "$char" "$(pc "$reset_color")"
}

function zle-keymap-select() {
	if [[ "$KEYMAP" == 'vicmd' ]]; then
		VIMODE='normal'
	elif [[ "$KEYMAP" == 'viins' || "$KEYMAP" == 'main' ]]; then
		VIMODE='insert'
	else
		VIMODE='?'
	fi
	zle reset-prompt
}

function accept-line() {
	VIMODE='insert'
	builtin zle .accept-line
}

function git_indicator() {
	if in_git_repo; then
		printf "%s %s%s " "$(pc "$fg_green")" "$(git_branch)" "$(pc "$reset_color")"
		local unpublished=$(git_unpushed_commits_indicator)
		if [[ -n "$unpublished" ]]; then
			echo -n "$unpublished "
		fi
	fi
}

function git_unpublished_commits() {
	git rev-list @{u}..HEAD 2>/dev/null | grep -c '^'
}

function git_unpushed_commits_indicator() {
	local num=$(git_unpublished_commits)
	if [[ "$num" -gt 0 ]]; then
		printf "%s$num%s" "$(pc "$fg_yellow")" "$(pc "$reset_color")"
	fi
}

function git_branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function git_upstream() {
	git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
}

PS1='$(host_indicator)$(cwd_indicator)$(git_indicator)$(terraform_version_indicator)$(terraform_workspace_indicator)$(kube_ctx_indicator)$(shell_profile_indicator)$(aws_profile_indicator)$(vimode_indicator)$(user_rc_indicator)'

if [[ "$SHELL_NAME" == 'zsh' ]]; then
	zle -N zle-keymap-select
	zle -N accept-line
fi
