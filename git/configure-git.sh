#!/bin/bash

gcg='git config --global'

$gcg color.ui 'auto'
$gcg user.name 'John Koelndorfer'
$gcg push.default 'simple'

# Use personal e-mail for the dotfiles repository.
git config user.email 'jkoelndorfer@gmail.com'

git config --global alias.current-branch 'rev-parse --abbrev-ref HEAD'
git config --global alias.delete-branch "!~/dotfiles/git/delete-branch"
git config --global alias.fix-authorship "!~/dotfiles/git/fix-authorship"
git config --global alias.new-branch '!sh -c "git fetch; git checkout -b $1 origin/master"'
git config --global alias.root 'rev-parse --show-toplevel'
git config --global alias.fzf-log 'log --color=always --pretty=format:"%C(yellow)%h %C(green)%an %C(blue)%ad %C(reset)%s" --date=iso --abbrev-commit'
git config --global diff.fbp.textconv "~/dotfiles/bin/gaming/factorio/deflate-blueprint"
