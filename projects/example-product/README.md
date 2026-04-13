# Example Product Project Workspace

This directory is the public, anonymized project workspace used by the harness examples.

## Contents

- `tasks.yml` — sample task registry.
- `active/`, `archived/`, `scratch/` — lifecycle directories retained with `.gitkeep` files.
- `case-studies/terminal-life/` — complete public case study showing a realistic task workspace with code, tests, checks, progress, and findings.

## Recommended reading order

1. `tasks.yml`
2. `case-studies/terminal-life/task.md`
3. `case-studies/terminal-life/repo/README.md`
4. `case-studies/terminal-life/repo/scripts/check.sh`

Real project workspaces should follow the same shape, but they should usually remain local/private because they can reveal roadmap, branch names, private repository paths, customer context, or internal tooling.
