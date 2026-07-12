#!/usr/bin/env bash
# Show local branch ahead/behind status for a workspace repo.
# Usage:
#   tools/check-branch-status.sh <workspace> <repo> [base]
set -euo pipefail

WORKSPACE="${1:?workspace is required}"
REPO="${2:?repo is required}"
BASE="${3:-main}"

HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$HARNESS_ROOT/projects/$WORKSPACE/repos/$REPO"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "Baseline repo not found: $REPO_DIR"
  exit 1
fi

echo "Fetching origin ..."
git -C "$REPO_DIR" fetch origin --prune

echo ""
echo "Branches compared with origin/$BASE:"
git -C "$REPO_DIR" for-each-ref --format='%(refname:short)' refs/heads | while read -r branch; do
  [[ -n "$branch" ]] || continue
  if git -C "$REPO_DIR" merge-base --is-ancestor "origin/$BASE" "$branch" 2>/dev/null; then
    ahead="$(git -C "$REPO_DIR" rev-list --count "origin/$BASE..$branch")"
    behind="$(git -C "$REPO_DIR" rev-list --count "$branch..origin/$BASE")"
    printf "  %-40s ahead=%-3s behind=%-3s\n" "$branch" "$ahead" "$behind"
  fi
done
