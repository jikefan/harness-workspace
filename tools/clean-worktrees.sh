#!/usr/bin/env bash
# Interactively remove merged local worktrees.
# Usage:
#   tools/clean-worktrees.sh [workspace]
set -euo pipefail

WORKSPACE="${1:-${HARNESS_WORKSPACE:-}}"
HARNESS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_ROOT="$HARNESS_ROOT/projects"

if [[ -n "$WORKSPACE" ]]; then
  WORKSPACES=("$PROJECTS_ROOT/$WORKSPACE")
else
  mapfile -t WORKSPACES < <(find "$PROJECTS_ROOT" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sort)
fi

for workspace_dir in "${WORKSPACES[@]}"; do
  [[ -d "$workspace_dir/worktrees" ]] || continue
  echo "Workspace: $(basename "$workspace_dir")"

  mapfile -t worktrees < <(find "$workspace_dir/worktrees" -mindepth 2 -maxdepth 2 -type d -print | sort)
  for wt in "${worktrees[@]}"; do
    [[ -d "$wt/.git" || -f "$wt/.git" ]] || continue
    status="$(git -C "$wt" status --short)"
    branch="$(git -C "$wt" branch --show-current)"

    if [[ -n "$status" ]]; then
      echo "  keeping dirty worktree: $wt ($branch)"
      continue
    fi

    upstream="$(git -C "$wt" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
    if [[ -z "$upstream" ]]; then
      echo "  keeping worktree without upstream: $wt ($branch)"
      continue
    fi

    git -C "$wt" fetch origin --prune >/dev/null 2>&1 || true
    if git -C "$wt" merge-base --is-ancestor "$branch" "$upstream" 2>/dev/null; then
      printf "  remove merged worktree %s (%s -> %s)? [y/N] " "$wt" "$branch" "$upstream"
      read -r answer
      case "$answer" in
        y|Y|yes|YES)
          git -C "$wt" worktree remove "$wt"
          ;;
        *)
          echo "  skipped"
          ;;
      esac
    else
      echo "  keeping unmerged worktree: $wt ($branch)"
    fi
  done
done
