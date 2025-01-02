if [[ "$(uname)" == 'Linux' ]]; then
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -l --color=auto --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
fi
alias rm='rm -i'
