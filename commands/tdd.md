---
description: Test-driven loop — failing test first, then implement until green
argument-hint: <feature or bug description>
---

Implement using strict TDD: $ARGUMENTS

1. Find the project's test runner and conventions (look at existing tests first).
2. Write the test(s) that capture the desired behavior. Run them and confirm they
   FAIL for the right reason — show me the failure output.
3. Implement the minimal change to make them pass. Do not modify the tests to fit
   the implementation.
4. Run the full relevant test suite + lint. Loop on failures.
5. Report: tests added, final pass/fail output, files changed.

If you cannot make the test fail first (e.g. behavior already exists), stop and tell me.
