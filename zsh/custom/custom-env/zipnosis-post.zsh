#!/usr/bin/env zsh

ssh-add "$REALHOME"/.ssh/paas-keys/*~*.pub &> /dev/null
