# If asdf is available, enable it.
#
# See https://github.com/asdf-vm/asdf.
_asdf_lib="$HOME/.asdf/asdf.sh"
if [[ -f "$_asdf_lib" ]]; then
    source "$_asdf_lib"
fi
unset _asdf_lib
