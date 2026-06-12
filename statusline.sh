#!/usr/bin/env bash
# Statusline: model · directory · git branch (+dirty marker) · context left.
# Claude Code pipes session JSON to stdin; we print one line.
exec python3 -c "
import json, os, subprocess, sys

d = json.load(sys.stdin)
model = d.get('model', {}).get('display_name', '?')
cwd = d.get('workspace', {}).get('current_dir') or os.getcwd()
parts = [model, os.path.basename(cwd) or cwd]

try:
    branch = subprocess.run(
        ['git', '-C', cwd, 'branch', '--show-current'],
        capture_output=True, text=True, timeout=2,
    ).stdout.strip()
    if branch:
        dirty = subprocess.run(
            ['git', '-C', cwd, 'diff', '--quiet'],
            capture_output=True, timeout=2,
        ).returncode != 0
        parts.append(branch + ('*' if dirty else ''))
except Exception:
    pass

pct = d.get('context', {}).get('used_percentage')
if pct is not None:
    parts.append('{}% left'.format(round(100 - pct)))

print(' · '.join(parts), end='')
"
