TERRAFORM_VERSION_DIRECTORY="$HOME/bin/_terraform"
TERRAFORM_VERSION=''
TERRAFORM_BIN='terraform'

function tf() {
    local -a tf_args

    # Create 'ws' as a tf alias. `tf ws` should be identical to `terraform workspace`,
    # except that if no valid mode is passed to `tf ws`, assume the given argument is
    # a workspace that should be selected.
    if [[ "$1" == 'ws' ]]; then
        shift
        tf_args=("${tf_args[@]}" 'workspace')
        if [[ "$1" =~ ^(new|list|show|select|delete)$ ]]; then
            tf_args=("${tf_args[@]}" "$@")
        else
            tf_args=("${tf_args[@]}" 'select' "$1")
        fi
    elif [[ "$1" =~ ^(select-version|select-ver)$ ]]; then
        shift
        local selected_tf_version=$1
        local tf_bin="${TERRAFORM_VERSION_DIRECTORY}/${selected_tf_version}/terraform"
        if [[ -x "$tf_bin" ]]; then
            TERRAFORM_BIN="$tf_bin"
            TERRAFORM_VERSION="$selected_tf_version"
            echo "selected terraform version $TERRAFORM_VERSION" >&2
            return
        else
            echo "no such terraform version '$selected_tf_version'" >&2
            echo "available terraform versions:" >&2
            find "$TERRAFORM_VERSION_DIRECTORY" -mindepth 1 -maxdepth 1 -type d | xargs -n1 basename | sed -e 's/^/    /' >&2
            return
        fi
    elif [[ "$1" == 'a' ]]; then
        clear
        if [[ -n "$TMUX" ]]; then
            tmux clear-history
        fi
        shift
        tf_args=('apply' "$@")
    else
        tf_args=("$@")
    fi
    "$TERRAFORM_BIN" "${tf_args[@]}"
}

function tfcd() {
    local target_directory=$(git-ls-directories | grep -E '(^|/)terraform/stack' | fzf)
    if [[ -z "$target_directory" ]]; then
        return 1
    fi
    cd "$(git root)/$target_directory"
}
