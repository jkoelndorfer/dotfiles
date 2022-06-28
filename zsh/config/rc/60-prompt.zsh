setopt PROMPT_SUBST

precmd_functions=(record_lastrc "${precmd_functions[@]}")

VIMODE='insert'

function aws_profile_indicator() {
    if [[ -n "$AWS_PROFILE" && "$AWS_PROFILE" != "$SHELL_PROFILE" ]]; then
        echo -n "%F{yellow} $AWS_PROFILE "
    elif if [[ -z "$AWS_PROFILE" && "$AWS_PROFILE" != "$SHELL_PROFILE" ]]; then
        echo -n "%F{yellow} default "
    fi
}

function cwd_indicator() {
    echo -n '%F{blue} %1~%f '
}

function host_indicator() {
    [[ -n "$SSH_CONNECTION" ]] && echo -n '%F{white}力 %m%f '
}

function shell_profile_indicator() {
    [[ -n "$SHELL_PROFILE" ]] && echo -n "%F{blue} $SHELL_PROFILE "
}

function rc_indicator() {
    local color='green'
    if [[ "$last_rc" != '0' ]]; then
        color='red'
    fi
    echo -n "%F{$color}>%f"
}

function record_lastrc() {
    last_rc="$?"
}

function kube_ctx_indicator() {
    # NOTE: This isn't 100% proper for looking up the current
    # Kubernetes context, but it avoids forking a process so
    # it is somewhat faster than invoking kubectl.
    local kube_config="$HOME/.kube/config"
    if ! [[ -f "$kube_config" ]]; then
        return
    fi
    local kube_config_content=$(< "$kube_config")
    if [[ "$kube_config_content" =~ 'current-context: *([0-9A-Za-z_-]+)' ]]; then
        local current_kube_ctx=${match[1]}
        echo "%F{cyan}ﴱ $current_kube_ctx "
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
        echo "%F{cyan} $tf_env%f "
    fi
}

function terraform_version_indicator() {
    if [[ -n "$TERRAFORM_VERSION" ]]; then
        echo "%F{#844fba}TF $TERRAFORM_VERSION%F{-} "
    fi
}

function user_indicator() {
    local color='green'
    if [[ "$EUID" == '0' ]]; then
        color='red'
    fi
    echo -n "%F{$color}>%f"
}

function vimode_indicator() {
    local color=''
    local char=''
    if [[ "$VIMODE" == 'normal' ]]; then
        color='yellow'
        char=''
    elif [[ "$VIMODE" == 'insert' ]]; then
        color='green'
        char=''
    else
        color='red'
        char='?'
    fi
    echo -n "%F{$color}$char%f"
}

function zle-keymap-select() {
    if [[ "$KEYMAP" == 'vicmd' ]]; then
        VIMODE='normal'
    elif [[ "$KEYMAP" == 'viins'  || "$KEYMAP" == 'main' ]]; then
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
        echo -n "%F{green} $(git_branch)%f "
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
        echo "%F{yellow}$num%f"
    fi
}

function git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function git_upstream() {
    git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
}

PS1='$(host_indicator)$(cwd_indicator)$(git_indicator)$(terraform_version_indicator)$(terraform_workspace_indicator)$(kube_ctx_indicator)$(shell_profile_indicator)$(aws_profile_indicator)$(vimode_indicator) $(user_indicator)$(rc_indicator) '
zle -N zle-keymap-select
zle -N accept-line
