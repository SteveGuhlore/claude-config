#!/usr/bin/env bash
# PostToolUse hook (Edit|Write): auto-format the edited file with whatever
# formatter the project already uses. Saves a lint-fix round trip (and the
# tokens it would burn). Always exits 0 — formatting is best-effort.
set -u

file=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null) || exit 0
[ -n "$file" ] && [ -f "$file" ] || exit 0

has() { command -v "$1" >/dev/null 2>&1; }

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.md)
    if [ -f node_modules/.bin/prettier ]; then
      node_modules/.bin/prettier --write "$file" >/dev/null 2>&1
    fi
    ;;
  *.py)
    if has ruff; then ruff format "$file" >/dev/null 2>&1
    elif has uv && [ -f uv.lock ]; then uv run ruff format "$file" >/dev/null 2>&1
    fi
    ;;
  *.go)
    has gofmt && gofmt -w "$file" >/dev/null 2>&1
    ;;
  *.rs)
    has rustfmt && rustfmt --edition 2021 "$file" >/dev/null 2>&1
    ;;
esac

exit 0
