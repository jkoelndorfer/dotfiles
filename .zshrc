# Path to installation of oh-my-zsh
ZSH="$HOME/.oh-my-zsh"
if [[ -n "$SUDO_USER" ]]; then
    ZSH="$(getent passwd "$SUDO_USER" | awk -F: '{ print $6 }')/.oh-my-zsh"
fi
export ZSH

ZSH_THEME="powerlevel9k"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
POWERLEVEL9K_TIME_FORMAT='%D{%F %H:%M:%S}'
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.zshconfig
