#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

python3 -m py_compile life.py tests/test_life.py
python3 -m unittest discover -s tests -v
python3 life.py --seed block --width 8 --height 5 --steps 1 --fps 0 --no-clear >/tmp/terminal-life-smoke.txt

grep -q "Generation 1" /tmp/terminal-life-smoke.txt

echo "terminal-life checks passed"
