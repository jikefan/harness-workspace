#!/usr/bin/env bash
# Clone a repository as a clean baseline.
# Usage:
#   tools/register-repo.sh <workspace> <repo-url> [repo-name]
set -euo pipefail

WORKSPACE="${1:?workspace is required, for example: my-work}"
REPO_URL="${2:?repo url is required, for example: github.com:owner/app.git}"
REPO_NAME="${3:-}"

HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE_ROOT="$HARNESS_ROOT/projects/$WORKSPACE"
REPOS_ROOT="$WORKSPACE_ROOT/repos"

if [[ -z "$REPO_NAME" ]]; then
  base="$(basename "$REPO_URL")"
  REPO_NAME="${base%.git}"
fi

TARGET="$REPOS_ROOT/$REPO_NAME"

if [[ -e "$TARGET" ]]; then
  echo "Repository baseline already exists: $TARGET"
  exit 1
fi

mkdir -p "$REPOS_ROOT" "$WORKSPACE_ROOT/staging" "$WORKSPACE_ROOT/worktrees"

echo "Cloning baseline:"
echo "  workspace: $WORKSPACE"
echo "  repo:      $REPO_NAME"
echo "  url:       $REPO_URL"
echo "  target:    $TARGET"

git clone "$REPO_URL" "$TARGET"

echo ""
echo "Done. Baseline created at:"
echo "  $TARGET"
echo ""
echo "Use this baseline for reading and pulling only. Create code changes with:"
echo "  tools/new-worktree.sh feat-example $REPO_NAME main $WORKSPACE"
