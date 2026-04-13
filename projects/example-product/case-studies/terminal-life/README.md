# Case Study: Terminal Life

This public case study shows what a small but complete harness-managed task can look like.

The example project implements **Conway's Game of Life** as a zero-dependency Python terminal application. It is intentionally small enough to read in one sitting, but complete enough to demonstrate task documentation, repo-local checks, tests, and handoff evidence.

## Why this case study exists

The root `projects/` directory can feel abstract if it only contains an anonymized task registry. This case study makes the workflow concrete:

- `task.md` explains the scope and done criteria.
- `progress.md` records a chronological work log.
- `findings.md` captures implementation decisions and gotchas.
- `repo/` acts like the task's working repository.
- `repo/scripts/check.sh` is the repo-local quality gate an agent should run before handoff.

## Run the demo

```bash
cd projects/example-product/case-studies/terminal-life/repo
python3 life.py --seed glider --width 40 --height 18 --steps 80 --fps 12
```

Other seeds:

```bash
python3 life.py --seed blinker --steps 20
python3 life.py --seed random --width 60 --height 24 --density 0.25 --steps 120
```

## Run checks

```bash
cd projects/example-product/case-studies/terminal-life/repo
./scripts/check.sh
```

The check script runs:

1. Python syntax compilation.
2. Unit tests using the standard library `unittest` runner.
3. A short non-interactive smoke run.

## What this demonstrates

A real project profile might contain private repository URLs, internal environment names, or customer-specific rules. This case study avoids all of that while still showing a realistic workflow shape that can be copied into private task workspaces.
