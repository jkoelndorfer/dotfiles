# This function labels fields as processed by awk. This is useful if you have lots of fields and
# want to know what field numbers are at a glance.
#
# This function is a bit rough and could use some cleanup, but works well enough.
# TODO: getopt?
function awkcf() {
    if [[ "$#" == 1 ]]; then
        fsarg=''
        file="$1"
    elif [[ "$#" == 2 ]]; then
        fsarg="$1"
        file="$2"
    elif [[ "$#" == 3 ]]; then
        fsarg="${1}${2}"
        file="$3"
    else
        echo "$0: unrecognized number of args" >&2
        return 1
    fi
    script='{ for(i=1; i <= NF; i++) { printf i"="$i; if (i != NF) printf FS; } printf "\n" }'
    # awk doesn't ignore empty args, so we need to pass "$fsarg" only if required.
    if [[ -n "$fsarg" ]]; then
        awk "$fsarg" "$script" "$file"
    else
        awk "$script" "$file"
    fi
}

# "header + grep"
# This function invokes grep, but always includes the first line of input in its output.
# Useful for include headers from programs like ps.
function hgrep() {
    local h; read h; echo "$h"
    grep "$@"
}

function hl() {
    grep --color=always -E "$@"
}
