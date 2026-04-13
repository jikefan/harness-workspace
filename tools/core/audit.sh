#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Harness workspace audit"
echo "Root: $ROOT"
echo

echo "Top-level layout:"
find "$ROOT" -maxdepth 1 -mindepth 1 -print | sort | sed "s#^$ROOT/##" | sed 's#^#  - #'

echo
if [ -f "$ROOT/AGENTS.md" ]; then
  bytes=$(wc -c < "$ROOT/AGENTS.md")
  echo "AGENTS.md: ${bytes} bytes"
else
  echo "Missing AGENTS.md"
fi

echo
for required in docs profiles projects tools templates artifacts tmp; do
  if [ -d "$ROOT/$required" ]; then
    echo "[OK] $required/"
  else
    echo "[MISSING] $required/"
  fi
done
