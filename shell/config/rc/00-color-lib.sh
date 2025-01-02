# This file provides color functionality that can be used in either bash or zsh.
#
# Variables are set with the proper escape sequences for various colors.
#
# To set a foreground color, use "$fg_COLORNAME" in a string. For a background
# color, use "$bg_COLORNAME" in a string. To bold text, use "$bold". To reset,
# use "$reset_color".
function color_code() {
	local color_name=$1
	local code

	if [[ "$color_name" == 'black' ]]; then
		code=0
	elif [[ "$color_name" == 'red' ]]; then
		code=1
	elif [[ "$color_name" == 'green' ]]; then
		code=2
	elif [[ "$color_name" == 'yellow' ]]; then
		code=3
	elif [[ "$color_name" == 'blue' ]]; then
		code=4
	elif [[ "$color_name" == 'magenta' ]]; then
		code=5
	elif [[ "$color_name" == 'cyan' ]]; then
		code=6
	elif [[ "$color_name" == 'white' ]]; then
		code=7
	fi
	printf '%s' "$code"
}

for color in black red green yellow blue magenta cyan white; do
	for w in foreground background; do
		if [[ "$w" == 'foreground' ]]; then
			tput_arg='setaf'
			w_abbrev='fg'
		elif [[ "$w" == 'background' ]]; then
			tput_arg='setab'
			w_abbrev='bg'
		fi

		color_term_code=$(tput "$tput_arg" "$(color_code "$color")")
		eval "${w_abbrev}_${color}=$(printf '%q' "${color_term_code}")"
	done

done
bold="$(tput bold)"
reset_color="$(tput sgr0)"
