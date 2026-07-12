#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
readme="$repo_root/README.md"
diagram="$repo_root/assets/harness-workspace-architecture.svg"

test -f "$diagram"
grep -Fq './assets/harness-workspace-architecture.svg' "$readme"
grep -Fq 'Baseline repositories' "$diagram"
grep -Fq 'Isolated worktree' "$diagram"
grep -Fq 'Pull request' "$diagram"
