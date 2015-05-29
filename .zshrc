# Path to installation of oh-my-zsh
REALHOME="$HOME"
if [[ -n "$SUDO_USER" ]]; then
    export REALHOME="$(getent passwd "$SUDO_USER" | awk -F: '{ print $6 }')"
fi
ZSH="$REALHOME/.oh-my-zsh"
export ZSH

ZSH_THEME="powerlevel9k"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
POWERLEVEL9K_TIME_FORMAT='%D{%F %H:%M:%S}'
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.zshconfig
