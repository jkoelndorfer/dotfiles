#!/bin/bash

gcg='git config --global'

$gcg color.ui 'auto'
$gcg user.name 'John Koelndorfer'
$gcg push.default 'simple'

# Use personal e-mail for the dotfiles repository.
git config user.email 'jkoelndorfer@gmail.com'

git config --global alias.current-branch 'rev-parse --abbrev-ref HEAD'
git config --global alias.root 'rev-parse --show-toplevel'
git config --global diff.fbp.textconv "~/dotfiles/bin/gaming/factorio/deflate-blueprint"
