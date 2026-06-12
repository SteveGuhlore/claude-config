#!/usr/bin/env bash
# Symlink this repo's config into ~/.claude. Idempotent; backs up anything
# it would overwrite to ~/.claude/backups/<timestamp>/.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
BACKUP_DIR="$CLAUDE_DIR/backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CLAUDE_DIR"

link() {
  local src="$REPO_DIR/$1" dst="$CLAUDE_DIR/$1"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    echo "backed up existing $1 -> $BACKUP_DIR/"
  fi
  ln -sfn "$src" "$dst"
  echo "linked $1"
}

link CLAUDE.md
link settings.json
link statusline.sh
link commands
link agents
link hooks

chmod +x "$REPO_DIR"/hooks/*.sh "$REPO_DIR"/statusline.sh

echo "Done. Start a new Claude Code session to pick up the config."
