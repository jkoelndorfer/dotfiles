function gb() {
	if [[ "$1" == "-a" ]]; then
		branch_addl_args='-a'
	fi
	branch="$(
		git branch -v $branch_addl_args --color=always |
			cut -c 3- |
			fzf --ansi --tiebreak length --preview='git log -n 10 --color=always $(echo {} | awk "{ print \$1 }")' |
			awk '{ print $1 }'
	)"
	[[ -n "$branch" ]] || return 1
	git checkout "$branch"
}

function gpu() {
	git push -u origin "$(git current-branch)"
}

function gc() {
	git commit --verbose $@
}

function git-ls-directories() {
	# This is an attempt at creating a sort of fast (but not 100% accurate)
	# list of directories in a git repository, including untracked ones.
	#
	# git ls-files will not produce a list of directories, so we need to
	# massage its output a little bit.
	#
	# grep excludes files without any '/', which are definitely not directories.
	# sed then strips off the last component of the path.
	# Lastly, sort -u ensures there are no duplicate directory entries.
	#
	# Untracked empty directories will not be discovered using this method.
	# git ls-files does not report them.
	{
		local root=$(git root)
		echo './'
		git ls-files --full-name "$root"
		git ls-files --exclude-standard -o --full-name "$root"
	} | grep '/' | sed -r -e 's#/[^/]+$##' | sort -u
}

function gcd() {
	local target_directory=$(git-ls-directories | fzf)
	if [[ -z "$target_directory" ]]; then
		return 1
	fi
	cd "$(git root)/$target_directory"
}

function gr() {
	local rebase_commit=$(
		git fzf-log |
			fzf --color "bg+:$SOLARIZED_BASE02_TERM16" --no-multi --ansi --preview='git log --patch -n 1 --color=always {1}' |
			awk '{ print $1 }'
	)
	if [[ -z "$rebase_commit" ]]; then
		return 1
	fi

	local current_branch=$(git current-branch)
	if git is-root-commit "$rebase_commit"; then
		git rebase -i --root "$current_branch"
	else
		git rebase -i "${rebase_commit}~1" "$current_branch"
	fi
}

function git() {
	local git_args=("$@")
	local git_alt_dir_args=()

	while [[ "$1" =~ ^--? ]]; do
		if [[ "$1" == '-C' ]]; then
			git_alt_dir_args=("$1" "$2")
			shift
		fi
		shift
	done

	local user_email_config=$(command git "${git_alt_dir_args[@]}" config --local -l 2>/dev/null | grep -E '^\s*user\.email\s*=')

	local subfunc=$1
	local allowed_subfuncs=(
		blame
		checkout
		clone
		init
		config
		describe
		diff
		is-root-commit
		fetch
		fzf-log
		log
		ls-files
		ls-remote
		pull
		rev-list
		rev-parse
		show
		status
	)

	local f
  local ok=0
	if [[ -z "$user_email_config" ]]; then
		for f in "${allowed_subfuncs[@]}"; do
			if [[ "$subfunc" == "$f" ]]; then
        ok=1
			fi
		done
  else
    ok=1
  fi

  if [[ "$ok" == 0 ]]; then
    echo 'fatal: set git config option `user.email` for this repository' >&2
    return 1
  fi

	command git "${git_args[@]}"
}

alias gco='git checkout'
alias gd='git diff -U200'
alias gds='git diff --staged -U200'
alias gpc='git --paginate status && git diff --staged -U200'
alias gs='git status --short'
