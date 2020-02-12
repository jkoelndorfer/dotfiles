if ! type -p gem &>/dev/null; then
    return
fi

# `gem environment gempath` will produce one or more paths separated
# by the standard colon, e.g.
#
# /home/$USER/.gem/ruby/2.7.0:/usr/lib/ruby/gems/2.7.0
gem_bin_paths=$(gem environment gempath | sed -r -e 's#(:|$)#/bin\1#g')
pathmunge "$gem_bin_paths" 'after'
unset gem_bin_paths
