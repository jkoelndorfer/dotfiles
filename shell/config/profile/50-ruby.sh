if ! type -p gem &>/dev/null; then
    return
fi

# `gem environment gempath` will produce one or more paths separated
# by the standard colon, e.g.
#
# /home/$USER/.gem/ruby/2.7.0:/usr/lib/ruby/gems/2.7.0
gem_bin_paths=$(gem environment gempath)
while read p; do
    pathmunge "$p/bin" 'after'
done <<< "$(echo "$gem_bin_paths" | tr ':' '\n')"
unset p
unset gem_bin_paths
