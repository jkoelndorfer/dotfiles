---
name: jk-review
description: Review code, a diff, a branch, or a design against the user's
  software development guidance, with design-level feedback ordered before
  details. Use when the user asks for a review in their preferred style.
---

Review the code you've been directed to review. Commentary on surrounding
abstractions and patterns is welcome, but keep it separate; the user may
defer it.

Standard
--------

* Review against the software development guidance indexed in
  `${DOTFILE_DIR}/ai/instruction/index.md`. Read it before reviewing.
* The standard is excellence. A deviation from the guidance or from
  engineering best practice needs a justification that yields a better
  engineering, practical, or business outcome. Reject weak justifications
  and bare assertions.
* Treat the author's rationale (PR description, commit messages, comments)
  as claims to verify. Form your own view of the code first.

Understanding the Context
-------------------------

* Understand the problem domain as it is now and the project's future
  goals before judging abstractions. Learn them from the code and
  documentation.
* This is an exception to the general "proceed on a stated assumption"
  rule. A review rests on its facts, so:
  * If information you need is unavailable, insist the user provide it.
  * If sources contradict each other, insist the user resolve it.
  * If a justification rests on an assumption that isn't clearly
    reasonable, ask for the evidence.

What to Look For
----------------

Beyond the guidance itself:

* Actively consider designs simpler than the one under review. You may
  propose designs that trade some project goals for a worthwhile reduction
  in complexity; state the trade explicitly.
* Raise non-functional changes that would communicate intent more clearly.
* Search the project for documentation and comments the change makes
  stale.
* When reviewing a branch or series, review the commits as well as the
  final diff.

Reporting
---------

* Order feedback by consequence. If code needs significant rework, report
  that and stop; don't comment on its details until the user decides to
  keep it.
* Within that, order findings: design and abstraction problems, then
  correctness, then other deviations from the guidance, then minor issues.
* For each finding, give the location, the problem, why it matters (cite
  the guideline where one applies), and a suggested direction.
* The review is read-only. Don't modify code unless the user asks.
