function source_nvm() {
    if [[ -f 'package.json' ]]; then
        source "$HOME/.nvm/nvm.sh"
    fi
}

chpwd_functions=("${chpwd_functions[@]}" source_nvm)
