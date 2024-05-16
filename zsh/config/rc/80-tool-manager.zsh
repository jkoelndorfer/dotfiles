[[ "$MISE_SOURCED" == '1' ]] && return 0
[[ "$ASDF_SOURCED" == '1' ]] && return 0

# If mise is available, prefer it over asdf.
if type mise > /dev/null 2>&1; then
  eval "$(mise activate)" > /dev/null 2>&1
  MISE_SOURCED=1
fi

# Otherwise, if asdf is available, enable it.
#
# See https://github.com/asdf-vm/asdf.
_asdf_lib="$HOME/.asdf/asdf.sh"
if [[ -f "$_asdf_lib" ]]; then
    source "$_asdf_lib"
    ASDF_SOURCED=1
fi
unset _asdf_lib
