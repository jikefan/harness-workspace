#!/usr/bin/env bash
# Create a read-only shared branch worktree, such as staging or develop.
# Usage:
#   tools/add-shared-worktree.sh <workspace> <repo> <branch>
set -euo pipefail

WORKSPACE="${1:?workspace is required}"
REPO="${2:?repo is required}"
BRANCH="${3:?branch is required, for example: staging or develop}"

HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_DIR="$HARNESS_ROOT/projects/$WORKSPACE/repos/$REPO"
WT_DIR="$HARNESS_ROOT/projects/$WORKSPACE/staging/$REPO"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "Baseline repo not found: $REPO_DIR"
  echo "Register it first with:"
  echo "  tools/register-repo.sh $WORKSPACE <repo-url> $REPO"
  exit 1
fi

if [[ -e "$WT_DIR" ]]; then
  echo "Shared worktree already exists: $WT_DIR"
  exit 1
fi

if ! git -C "$REPO_DIR" ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
  echo "Remote branch not found: origin/$BRANCH"
  exit 1
fi

mkdir -p "$(dirname "$WT_DIR")"

echo "Fetching origin/$BRANCH ..."
git -C "$REPO_DIR" fetch origin "$BRANCH"

echo "Creating shared worktree:"
echo "  $WT_DIR"
if git -C "$REPO_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$REPO_DIR" worktree add "$WT_DIR" "$BRANCH"
else
  git -C "$REPO_DIR" worktree add --track -b "$BRANCH" "$WT_DIR" "origin/$BRANCH"
fi

echo ""
echo "Done. Treat this worktree as read-only."
