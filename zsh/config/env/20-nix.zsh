[[ "$NIX_SOURCED" == '1' ]] && return 0

pre_nix_path=$PATH

# Primarily for Nix on macOS. Prefer GNU coreutils over BSD coreutils.
nix_profile='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
if [[ -f "$nix_profile" ]]; then
    source "$nix_profile"
else
    return 0
fi

# Nix will put its binaries at the front of our PATH.
#
# That's actually not desireable on macOS. Non-system coreutil
# binaries can cause really weird behavior.
new_path_len=${#PATH}
previous_path_len=${#pre_nix_path}
nix_path=${PATH[0,$(( new_path_len - previous_path_len - 1))]}

export PATH="$pre_nix_path:$nix_path"

unset nix_profile
unset new_path_len
unset previous_path_len
unset pre_nix_path
unset nix_path

export NIX_SOURCED=1
