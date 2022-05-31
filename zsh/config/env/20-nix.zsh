# Primarily for Nix on macOS. Prefer GNU coreutils over BSD coreutils.
nix_profile='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
[[ -f "$nix_profile" ]] && source "$nix_profile"
unset nix_profile
