#!/bin/bash

function gcg() {
	git config --global "$@"
}

# Always start from a clean configuration.
rm -f "${HOME}/.gitconfig"

gcg color.ui 'auto'
gcg user.name 'John Koelndorfer'
gcg push.default 'simple'

# Use personal e-mail for the dotfiles repository.
git config user.email 'john@johnk.io'

gcg alias.current-branch 'rev-parse --abbrev-ref HEAD'
gcg alias.default-branch "!~/dotfiles/git/default-branch"
gcg alias.delete-branch "!~/dotfiles/git/delete-branch"
gcg alias.fix-authorship "!~/dotfiles/git/fix-authorship"
gcg alias.new-branch '!sh -c "git fetch; git checkout -b $1 origin/master"'
gcg alias.root 'rev-parse --show-toplevel'
gcg alias.fzf-log 'log --color=always --pretty=format:"%C(yellow)%h %C(green)%an %C(blue)%ad %C(reset)%s" --date=iso --abbrev-commit'
gcg alias.is-root-commit '!~/dotfiles/git/is-root-commit'
gcg diff.fbp.textconv "~/dotfiles/bin/gaming/factorio/deflate-blueprint"

gcg 'url.ssh://git@github.com/.insteadOf' 'https://github.com/'
