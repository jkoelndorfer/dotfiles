export GOPATH="$HOME/.local/go:$HOME/src/go"
[[ -d "$HOME/.local/go" ]] || mkdir -p "$HOME/.local/go"
[[ -d "$HOME/src/go" ]] || mkdir -p "$HOME/src/go"

# Go utilities will end up here when we call GoInstallBinaries
# in vim. They need to be in the $PATH for deoplete completion
# to work correctly.
pathmunge "$HOME/.local/go/bin"
