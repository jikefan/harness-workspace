#!/usr/bin/env bash
set -euo pipefail
PROJECT="${1:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -z "$PROJECT" ]; then
  echo "Usage: tools/harness task-status <project>" >&2
  exit 2
fi

TASKS="$ROOT/projects/$PROJECT/tasks.yml"
if [ ! -f "$TASKS" ]; then
  echo "No task registry found: $TASKS" >&2
  exit 1
fi

echo "Task registry: $TASKS"
cat "$TASKS"
