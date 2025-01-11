function host() {
  local cmd=("$@")

  if [[ -z "${cmd[*]}" ]]; then
    cmd=(bash)
  fi

  distrobox-host-exec "${cmd[@]}"
}
