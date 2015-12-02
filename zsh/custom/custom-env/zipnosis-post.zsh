#!/usr/bin/env zsh

ssh-add "$REALHOME"/.ssh/multideploy-keys/*~*.pub &> /dev/null
