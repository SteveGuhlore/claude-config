---
description: Plan-first discipline — explore, design, get approval before touching code
argument-hint: <task description>
---

Task: $ARGUMENTS

Do NOT write or edit any code yet. Instead:

1. Restate the task in one sentence; flag any ambiguity that changes the design.
2. Explore the relevant code (use the `scout` subagent for broad searches) and identify
   the files that must change, with `file:line` references.
3. Produce a numbered implementation plan: steps, ordering, risks, and how each step
   will be verified (which test/command proves it works).
4. Note anything you'd explicitly NOT do (scope boundary).

End with the plan and wait for my approval before implementing.
