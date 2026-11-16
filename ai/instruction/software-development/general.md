Software Development - General
==============================

Priorities
----------

In order:

1. Correctness is paramount.
   * Where correctness cannot be guaranteed, fail intentionally with a clear
     message stating why.
   * Fix root causes, not symptoms. Don't add workarounds that mask a
     defect. If only a workaround is feasible, label it as one and record
     the underlying issue.
2. Explicitness. Changes in behavior, especially disabling features or
   safeguards, require a deliberate signal, never an omission.
   * Disable things with an explicit value, such as
     `SIGNATURE_VALIDATION=DISABLED`. Treat a missing or empty value as an
     error, not as an implicit "off".
   * Defaults are acceptable when they are the safe, expected behavior.
     Omitting a value must never weaken safeguards or turn off
     functionality.
   * Choosing an opinionated component, such as instantiating a well-named
     class, is an explicit opt-in to its behavior, provided that behavior
     wouldn't be extremely surprising to someone with modest familiarity
     once it's explained.
3. Simplicity. Software should be as simple as it can be, and as complex as
   it has to be.
4. Efficiency is context-dependent.
  * Developer efficiency is highly valued. Engineers should be able to
     build, test, and validate their work locally, with fast feedback,
     rather than waiting on CI pipelines. See Development Workflow.
   * Avoid approaches that are wildly inefficient when a reasonable
     alternative exists, such as accidental quadratic behavior or unbounded
     resource use.
   * Beyond that, optimize only with evidence from measurement.

Design
------

* Design so that likely future enhancements can be added cleanly, without
  building them now. Don't invest in extension points that are unlikely to
  be used.
* Software must remain maintainable by people. Favor clarity over
  cleverness.
* Software should not be surprising. Names match behavior, side effects are
  evident, and interfaces behave like their peers.
* Maintain a single source of truth. Derive rather than duplicate data,
  configuration, and definitions.
* Validate input at system boundaries. Internal code may trust validated
  data.
* Prefer designs that make invalid states unrepresentable.
* Prefer a few absolute constraints over many edge cases, exceptions, and
  gotchas.
* When imposing a constraint, provide an escape hatch if there is a real,
  potential need for one. It may be less convenient than the constrained
  path and needn't take much effort to build, but it must be usable with
  sane development practices.
* Build in layers. Lower-level components are general-purpose building
  blocks and don't impose opinions. Higher-level components compose them,
  assume more, and are more concise to use. Typically, the escape hatch is
  to use a lower-level component.
* Abstractions solve their problem completely from the caller's
  perspective, even if they don't yet cover the whole problem domain.
* Prefer sensible defaults over configuration. Add options only for real,
  known needs; serve other conceivable needs through lower layers.
* Follow the project's existing conventions, then language idioms unless
  there is a strong reason not to.If a convention is sub-optimal, follow
  it anyway and raise it as a separate issue.
* Never silently swallow errors. Error messages should state what went wrong
  and, where possible, how to fix it.
* Treat new dependencies as a design decision. Prefer the standard library
  and existing dependencies.
* Comments explain why. Code explains what.
* Don't leave behind dead code, commented-out code, or unused abstractions.

Development Workflow
--------------------

* Effective local development is a high priority. Account for it in system
  design.
* Run the software the same way in every environment: local, dev, and
  production. Maximize consistency between them.
  * Local development may deviate from higher environments where that
    meaningfully improves efficiency. Even then, preserve the behavior of
    higher environments as closely as possible.
* Each CI step is a script that also runs locally. CI calls the scripts;
  it does not contain the logic. Avoid CI steps that "do a bunch of stuff".
  Every CI check must be runnable locally without pushing.
* Make the workflow hard to do wrong, and avoid unnecessary friction.
* For local development, prefer engineers' own credentials over shared
  service accounts or secrets.

Compatibility
-------------

* Public interfaces, file formats, protocols, and persisted data are
  contracts. Don't break them without an explicit decision.
* When a break is necessary, provide a migration path and deprecate before
  removing.

Commits
-------

* Each commit is one logical change, whether one line or many.
* Every commit passes the project's automated tests, linting, and other
  checks.
* Keep refactoring, formatting, and behavior changes in separate commits.
* Update documentation in the same commit as the behavior it describes.
* Fixes to unpublished commits belong in the commit they fix, not in a
  follow-up commit.
* Message format:
  * Subject: `<subsystem>: <change in imperative mood>`, for example
    `foo: Disallow barring`.
  * Derive the subsystem from the project's history and structure.
  * The body explains why the change is needed and anything non-obvious. Omit
    it when the subject is sufficient.
  * Wrap the body at 72 columns.

Version Control
---------------

* The user prefers `jj`. Use `jj` or `git`, whichever you're comfortable
  with.
* Repositories may contain a `.jj` directory and show a detached `HEAD`.
  This is normal. Don't "fix" it.
* Deliver finished work as commits on a named branch (a `jj` bookmark or
  `git` branch) so the user can retrieve it.
* Use non-interactive forms of commands.
* Don't leave conflicted commits in the final history.
* Don't rewrite commits that have been published or that others have built
  on.

Testing
-------

* New or enhanced features include tests, where appropriate.
* Bug fixes include a regression test, where practical.
* Test behavior, not implementation details.
* Prefer real implementations over stubs. Stub only where a real
  implementation would have significant side effects, such as generating
  network traffic or accessing a live service.
* Most tests run entirely locally. Tests that call remote services are
  opt-in and must be explicitly enabled.
* Tests must always:
  * Clean up after themselves.
  * Modify only resources they create.
  * Write only to non-production instances, if they access remote services.
    Test code must never modify production.
* Tests are deterministic. Avoid dependence on time, ordering, network, or
  shared state unless that is what's under test.
* Builds are reproducible. Pin dependencies.

Introducing a New Pattern
-------------------------

1. Implement the new common code.
2. Migrate each consumer in its own commit.
3. Once everything is migrated, delete the legacy common code, if
   applicable.
