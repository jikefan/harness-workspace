#!/usr/bin/env bash
# Pull baseline and shared worktree checkouts.
# Usage:
#   tools/pull-baselines.sh [workspace]
set -euo pipefail

WORKSPACE="${1:-${HARNESS_WORKSPACE:-}}"
HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_ROOT="$HARNESS_ROOT/projects"

if [[ -n "$WORKSPACE" ]]; then
  WORKSPACES=("$PROJECTS_ROOT/$WORKSPACE")
else
  mapfile -t WORKSPACES < <(find "$PROJECTS_ROOT" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sort)
fi

if [[ "${#WORKSPACES[@]}" -eq 0 ]]; then
  echo "No workspaces found under $PROJECTS_ROOT"
  exit 0
fi

pull_repo() {
  local repo="$1"
  local branch
  branch="$(git -C "$repo" branch --show-current)"
  if [[ -z "$branch" ]]; then
    echo "  Skipping detached worktree: $repo"
    return
  fi
  echo "  $repo ($branch)"
  git -C "$repo" pull --ff-only origin "$branch"
}

for workspace_dir in "${WORKSPACES[@]}"; do
  [[ -d "$workspace_dir" ]] || continue
  echo "Workspace: $(basename "$workspace_dir")"

  for repo in "$workspace_dir"/repos/*; do
    [[ -d "$repo/.git" ]] || continue
    pull_repo "$repo"
  done

  for repo in "$workspace_dir"/staging/*; do
    [[ -d "$repo/.git" || -f "$repo/.git" ]] || continue
    pull_repo "$repo"
  done
done
