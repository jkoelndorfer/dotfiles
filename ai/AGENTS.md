AI Agent Instructions
=====================

Sandbox Container
-----------------

* When `JK_SBCTR=true` in the environment, you are operating inside a custom
  sandbox. Guidance in this section only applies when `JK_SBCTR=true`.

* `${HOME}/ai/src` is the directory containing repositories you can work in.
  These repositories are checkouts just for you; the user does not work in
  them directly.
    * Manage the state of these repositories as you see fit.
    * When finalizing work in these repositories, ensure you create a commit so
      the user can fetch it.

* `${HOME}/src` contains the user's repository checkouts.
    * You cannot write to anything located in `${HOME}/src`.
    * The directories here are assumed to align with what you have in
      `${HOME}/ai/src` unless you find evidence to the contrary. If you do,
      raise that as an issue.
    * If asked to base your work on a commit and you cannot locate it, try
      fetching from the user's copy in `${HOME}/src`.
    * The user prefers `jj` for version control, so inspection of these
      repositories may show a detached `HEAD` or a `.jj` directory in the
      repository root.

* `$HOME` is a sandboxed home directory for you. If you need to hand off data
  to the user outside of a repository, `$HOME` is a good way to do that.

* If you want information about the sandbox container implementation, see
  `${HOME}/dotfiles/bin/dev/sbctr`.
