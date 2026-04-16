#!/usr/bin/env bash
set -euo pipefail
PROJECT="${1:-}"
TASK_ID="${2:-}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [ -z "$PROJECT" ] || [ -z "$TASK_ID" ]; then
  echo "Usage: tools/harness archive-task <project> <task-id>" >&2
  exit 2
fi

exec python3 "$ROOT/tools/core/archive_task.py" "$PROJECT" "$TASK_ID"
