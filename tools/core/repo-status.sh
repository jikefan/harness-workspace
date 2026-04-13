#!/usr/bin/env bash
set -euo pipefail
PROJECT="${1:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -z "$PROJECT" ]; then
  echo "Usage: tools/harness repo-status <project>" >&2
  exit 2
fi

BASE="$ROOT/projects/$PROJECT"
if [ ! -d "$BASE" ]; then
  echo "No project workspace found: $BASE" >&2
  exit 1
fi

find "$BASE" -type d -name .git -prune | while read -r gitdir; do
  repo="${gitdir%/.git}"
  echo
  echo "== $repo =="
  git -C "$repo" branch --show-current || true
  git -C "$repo" status --short || true
done
