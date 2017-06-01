#!/usr/bin/env zsh

alias ack="ack --color --pager='$PAGER'"
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -l --color=auto'
alias rm='rm -i'

# yum uses a different cache for users and root.  It does not make sense to
# maintain two caches, so use `sudo yum` instead.
alias yum='sudo yum'

alias gco='git checkout'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gpc='git status | less; git diff --staged'
alias gc='git commit'
