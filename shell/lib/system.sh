# Returns true if this system is an "atomic" Linux
# system with a high degree of sandboxing.
function is-atomic-linux-host() {
  local os_release
  local cmd

  if in-distrobox; then
    cmd=(distrobox-host-exec which rpm-ostree)
  else
    cmd=(which rpm-ostree)
  fi

  "${cmd[@]}" >/dev/null 2>&1
}

# Returns true if this shell is running directly
# in an atomic Linux system context (i.e. not
# within a container / distrobox).
function in-atomic-linux-context() {
  is-atomic-linux-host && ! in-distrobox
}

# Returns true if the shell is running inside
# a distrobox container.
function in-distrobox() {
  [[ -n "$DISTROBOX_ENTER_PATH" ]]
}
