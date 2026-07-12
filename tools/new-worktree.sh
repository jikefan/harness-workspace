#!/usr/bin/env bash
# Create an isolated implementation worktree.
# Usage:
#   tools/new-worktree.sh <branch> <repo> [base] [workspace]
#
# Examples:
#   tools/new-worktree.sh feat-login-polish app staging my-work
#   tools/new-worktree.sh hotfix-payment-timeout api main my-work
set -euo pipefail

BRANCH="${1:?branch is required, for example: feat-login-polish}"
REPO="${2:?repo is required, for example: app}"
BASE="${3:-}"
WORKSPACE="${4:-${HARNESS_WORKSPACE:-}}"

HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [[ -z "$WORKSPACE" ]]; then
  mapfile -t candidates < <(find "$HARNESS_ROOT/projects" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sort)
  if [[ "${#candidates[@]}" -eq 1 ]]; then
    WORKSPACE="$(basename "${candidates[0]}")"
  else
    echo "Workspace is required. Pass it as the 4th argument or set HARNESS_WORKSPACE."
    echo "Example:"
    echo "  tools/new-worktree.sh $BRANCH $REPO main my-work"
    exit 1
  fi
fi

case "$BRANCH" in
  hotfix-*|hot-*)
    BASE="${BASE:-main}"
    ;;
  feat-*|feature-*)
    BASE="${BASE:-staging}"
    ;;
  fix-*)
    if [[ -z "$BASE" ]]; then
      echo "Branch prefix 'fix-' is ambiguous. Pass the base branch explicitly."
      echo "Examples:"
      echo "  tools/new-worktree.sh $BRANCH $REPO main $WORKSPACE"
      echo "  tools/new-worktree.sh $BRANCH $REPO staging $WORKSPACE"
      exit 1
    fi
    ;;
  *)
    if [[ -z "$BASE" ]]; then
      echo "Base branch is required for branch '$BRANCH'."
      echo "Example:"
      echo "  tools/new-worktree.sh $BRANCH $REPO main $WORKSPACE"
      exit 1
    fi
    ;;
esac

REPO_DIR="$HARNESS_ROOT/projects/$WORKSPACE/repos/$REPO"
WT_DIR="$HARNESS_ROOT/projects/$WORKSPACE/worktrees/$BRANCH/$REPO"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "Baseline repo not found: $REPO_DIR"
  echo "Register it first with:"
  echo "  tools/register-repo.sh $WORKSPACE <repo-url> $REPO"
  exit 1
fi

if [[ -e "$WT_DIR" ]]; then
  echo "Worktree already exists: $WT_DIR"
  exit 1
fi

if ! git -C "$REPO_DIR" ls-remote --exit-code --heads origin "$BASE" >/dev/null 2>&1; then
  echo "Remote base branch not found: origin/$BASE"
  exit 1
fi

mkdir -p "$(dirname "$WT_DIR")"

echo "Fetching origin/$BASE ..."
git -C "$REPO_DIR" fetch origin "$BASE"

if git -C "$REPO_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Local branch already exists. Adding worktree for $BRANCH ..."
  git -C "$REPO_DIR" worktree add "$WT_DIR" "$BRANCH"
else
  echo "Creating worktree from origin/$BASE ..."
  git -C "$REPO_DIR" worktree add --no-track -b "$BRANCH" "$WT_DIR" "origin/$BASE"
fi

echo ""
echo "Done:"
echo "  $WT_DIR"
echo ""
echo "Next:"
echo "  cd $WT_DIR"
