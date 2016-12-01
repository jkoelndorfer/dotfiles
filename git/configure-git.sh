#!/bin/bash

gcg='git config --global'

$gcg color.ui 'auto'
$gcg user.name 'John Koelndorfer'
$gcg push.default 'upstream'

# Use personal e-mail for the dotfiles repository.
git config user.email 'jkoelndorfer@gmail.com'
