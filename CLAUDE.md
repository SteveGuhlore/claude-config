# Global working agreement

Lean by design — every line here costs tokens in every session. Add sparingly.

## Workflow
- Non-trivial change? State a 3–6 bullet plan first (or use `/plan`), then implement.
- Done means verified: run the project's tests/lint and report real output, not assumptions.
- Small, reviewable commits; imperative messages; never commit secrets or generated noise.

## Code
- Match the surrounding style and idiom; don't introduce dependencies without flagging it.
- Comments only for constraints the code can't express. No commented-out code.

## Token discipline
- Broad searches go to the `scout` subagent (Haiku); read only the file regions you need.
- Lead with the result; keep prose tight; no restating file contents back to me.
- When compacting: always preserve the list of modified files, the active task, and the
  exact test/build commands for this project.
- Prefer CLIs (`gh`, `aws`, etc.) over MCP servers when both exist — MCP schemas cost context.

## Stack defaults (polyglot)
- **TS/Node**: detect package manager from lockfile (pnpm > yarn > bun > npm). Typecheck with the repo's script, else `tsc --noEmit`.
- **Python**: prefer `uv run` when `uv.lock` exists; tests via `pytest`; lint via `ruff`.
- **Go**: `go vet ./...` then `go test ./...`.
- **Rust**: `cargo check` before `cargo test`; `cargo clippy` for lint.
