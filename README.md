# claude-config

A user-level Claude Code configuration tuned for **fast iteration with balanced token
efficiency**, across a polyglot stack (TypeScript/Node, Python, Go, Rust), used both on
local CLI/IDE and claude.ai/code cloud sessions.

## Install

```bash
git clone git@github.com:steveguhlore/claude-config.git
cd claude-config && ./install.sh
```

`install.sh` symlinks everything into `~/.claude` (backing up whatever was there), so
`git pull` updates the live config.

For cloud sessions (claude.ai/code), add `bootstrap.sh` to your environment's setup
script — it fetches this repo into the fresh container and runs the installer. See the
step-by-step in that file's header.

Note: cloud sandboxes route `git` through a proxy scoped to the *session's own* repo, so
a plain `git clone` of this repo from another repo's environment returns 403. `bootstrap.sh`
handles this by falling back to a public tarball download over normal HTTPS, and it never
hard-fails the host setup script if the fetch is blocked — so a restricted network policy
degrades to "no custom config" rather than a broken environment. If even the tarball is
blocked, copy the pieces into the project's own `.claude/` directory instead.

## How the pieces form one system

| Layer | File(s) | Job |
|---|---|---|
| Memory | `CLAUDE.md` | Global working agreement. Deliberately under 30 lines — bloated memory files get ignored and cost tokens every session. |
| Guardrails | `settings.json` | Permission allowlist for known-safe test/lint/build/git-read commands (no prompt stalls), `ask` on history-rewriting git, `deny` on secrets and force-push. |
| Automation | `hooks/format-on-edit.sh` | PostToolUse hook formats every edited file with the project's own formatter — eliminates the "fix lint" round trip and the tokens it burns. |
| Delegation | `agents/scout.md` (Haiku), `agents/verifier.md` (Sonnet) | Verbose work (codebase sweeps, test runs) happens in cheap, disposable contexts; only conclusions return to the main session. |
| Workflows | `commands/` | `/plan` (design before code), `/tdd` (failing test first), `/ship` (verify → self-review → commit → PR), `/catchup` (token-cheap session bootstrap). |
| Awareness | `statusline.sh` | Model · dir · branch+dirty · context remaining — context is the resource that matters; watch it continuously. |

The loop these create: **`/catchup` → `/plan` → implement (scout for searches, hooks keep
code formatted) → `/tdd` or `verifier` for proof → `/ship`** — with permissions tuned so
the whole cycle rarely stops to ask.

## Token-efficiency rules baked in

- CLAUDE.md stays minimal; per-workflow detail lives in commands/agents that load on demand.
- Haiku for search-shaped subagent work; bigger models only where judgment is needed.
- Compaction instructions in CLAUDE.md preserve modified files + test commands.
- CLIs over MCP servers where both exist; keep MCP servers per-project in `.mcp.json`,
  few in number — unused server schemas are pure context tax.
- Use `/clear` between unrelated tasks and `/fewer-permission-prompts` periodically to
  mine transcripts for new allowlist entries.

## Further reading

- [Claude Code best practices](https://code.claude.com/docs/en/best-practices) — canonical CLAUDE.md include/exclude guidance
- [Managing costs](https://code.claude.com/docs/en/costs#reduce-token-usage)
- [obra/superpowers](https://github.com/obra/superpowers) — popular skills framework (TDD, debugging, planning methodologies)
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) — large community config reference
- [Optimising MCP context usage](https://scottspence.com/posts/optimising-mcp-server-context-usage-in-claude-code)
