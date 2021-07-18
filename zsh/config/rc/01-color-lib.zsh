# zsh provides handy color definitions for you out of the box!
#
# This will permit you to use $fg, $fg_bold, $bg, $bg_bold, $reset_color,
# and $bold_color.
#
# For example:
# echo "${fg[red]}red text${reset_color} plain text"
#
# See https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors.
autoload colors
colors

# Allows zsh to do color interpolation. Per zshzle(1):
#
# > Some  modern terminal emulators have support for 24-bit true colour (16 million colours).
# > In this case, the hex triplet format can be used. This consists of a `#' followed by either
# > a three or six digit hexadecimal number describing the red, green and blue components of
# > the colour. Hex triplets can also be used with 88 and 256 colour terminals via the
# > zsh/nearcolor module (see zsh‐modules(1)).
autoload zsh/nearcolor
