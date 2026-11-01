#!/bin/bash

set -euo pipefail

# See https://github.com/jj-vcs/jj/discussions/5812.

function cs() {
	jj config set --user "$@"
}

if ! type jj >/dev/null 2>&1; then
	printf 'jj not found; skipping setup\n' >&2
	exit 0
fi

cs user.name 'John Koelndorfer'

cs 'revset-aliases."trunk()"' 'latest((present(master) | present(main)) & remote_bookmarks())'
cs 'revset-aliases."stack()"' 'ancestors(reachable(@, mutable()), 2)'
cs 'revset-aliases."stack(x)"' 'ancestors(reachable(x, mutable()), 2)'
cs 'revset-aliases."stack(x, n)"' 'ancestors(reachable(x, mutable()), n)'

cs 'aliases.mark' '["util", "exec", "--", "jj-mark"]'
cs 'aliases.push' '["util", "exec", "--", "jj-mark", "--push"]'
cs 'aliases.retrunk' '["util", "exec", "--", "jj-fetch-rebase", "-d", "trunk()"]'
