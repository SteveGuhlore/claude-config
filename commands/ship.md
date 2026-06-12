---
description: Verify → self-review → commit → push → PR, in one pass
argument-hint: [optional PR title]
---

Ship the current work: $ARGUMENTS

1. Run the project's test + lint + typecheck (whatever exists). All must pass —
   fix failures caused by this change; report pre-existing ones separately.
2. Self-review the full diff (`git diff` + staged): look for debug leftovers,
   accidental files, missing test coverage, secrets. Fix what you find.
3. If on the default branch, create a feature branch first.
4. Commit with a clear imperative message; push with `-u`.
5. Open a PR: summary of what/why, test evidence, and any follow-ups. Use the title
   from $ARGUMENTS if given.
6. Offer to watch the PR for CI results and review comments.
