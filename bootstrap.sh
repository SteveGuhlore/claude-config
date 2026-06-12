#!/usr/bin/env bash
# Cloud-session bootstrap: fetch this repo and install it into ~/.claude.
# Intended for a claude.ai/code environment setup script:
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/SteveGuhlore/claude-config/main/bootstrap.sh)
#
# For a private repo, set CLAUDE_CONFIG_TOKEN (fine-grained PAT, read-only
# contents scope) as an environment variable in the environment settings.
set -euo pipefail

REPO="SteveGuhlore/claude-config"
DIR="$HOME/.claude-config"

if [ -n "${CLAUDE_CONFIG_TOKEN:-}" ]; then
  URL="https://x-access-token:${CLAUDE_CONFIG_TOKEN}@github.com/${REPO}.git"
else
  URL="https://github.com/${REPO}.git"
fi

if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only >/dev/null 2>&1 || true
else
  git clone --depth 1 "$URL" "$DIR"
fi

"$DIR/install.sh"
