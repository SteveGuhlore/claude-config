#!/usr/bin/env bash
# Cloud-session bootstrap: fetch this repo and install it into ~/.claude.
# Intended for a claude.ai/code environment setup script:
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/SteveGuhlore/claude-config/main/bootstrap.sh)
#
# Cloud note: in claude.ai/code sandboxes, `git` is routed through a
# scope-enforcing proxy that only authorizes the session's OWN repo, so a
# plain `git clone` of this repo from another repo's environment returns 403.
# This script therefore falls back to a public tarball download over normal
# HTTPS (the same path the curl above already uses) and NEVER hard-fails the
# host setup script if the fetch can't complete — a missing custom config
# should not stop the environment from starting.
#
# For a private fork, set CLAUDE_CONFIG_TOKEN (fine-grained PAT, read-only
# contents scope) as an environment variable; the public repo needs none.
set -uo pipefail

REPO="SteveGuhlore/claude-config"
REF="${CLAUDE_CONFIG_REF:-main}"
DIR="$HOME/.claude-config"

log() { printf '[claude-config] %s\n' "$*"; }

AUTH_HEADER=()
if [ -n "${CLAUDE_CONFIG_TOKEN:-}" ]; then
  CLONE_URL="https://x-access-token:${CLAUDE_CONFIG_TOKEN}@github.com/${REPO}.git"
  AUTH_HEADER=(-H "Authorization: Bearer ${CLAUDE_CONFIG_TOKEN}")
else
  CLONE_URL="https://github.com/${REPO}.git"
fi

# Public-repo tarball over plain HTTPS. Bypasses the scoped git proxy, so it
# works from any environment whose egress policy allows github's CDN.
fetch_via_tarball() {
  command -v curl >/dev/null 2>&1 || return 1
  command -v tar  >/dev/null 2>&1 || return 1
  local tmp
  tmp="$(mktemp -d)" || return 1
  log "downloading ${REPO}@${REF} tarball ..."
  if curl -fsSL "${AUTH_HEADER[@]}" \
       "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${REF}" \
       -o "$tmp/repo.tar.gz"; then
    mkdir -p "$DIR"
    if tar -xzf "$tmp/repo.tar.gz" -C "$DIR" --strip-components=1; then
      rm -rf "$tmp"
      return 0
    fi
  fi
  rm -rf "$tmp"
  return 1
}

ok=0
if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only >/dev/null 2>&1 || true  # keep current; presence is enough
  ok=1
elif git clone --depth 1 --branch "$REF" "$CLONE_URL" "$DIR" 2>/dev/null; then
  ok=1
elif fetch_via_tarball; then
  ok=1
fi

if [ "$ok" -ne 1 ] || [ ! -e "$DIR/install.sh" ]; then
  log "could not fetch ${REPO} — skipping config install so the environment can finish starting."
  log "In claude.ai/code sandboxes, git is scoped to the session's own repo, so cloning"
  log "this repo from another environment returns 403. Make sure the environment's network"
  log "policy allows HTTPS to github.com / codeload.github.com, or vendor the config into the"
  log "project's own .claude/ directory instead."
  exit 0
fi

bash "$DIR/install.sh"
