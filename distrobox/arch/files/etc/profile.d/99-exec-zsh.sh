# On Fedora Kinoite, the default shell is bash.
# zsh is not present and installing software using
# rpm-ostree is discouraged.
#
# Because our system's user has bash as a default shell,
# we get that inside the distrobox container, too.
#
# This file helps smooth things over by automatically
# running zsh for us.

zsh_path='/usr/bin/zsh'
if [[ "$0" != "$zsh_path" ]]; then
  exec "$zsh_path" -l
fi
