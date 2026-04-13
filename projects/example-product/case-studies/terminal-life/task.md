# Task: terminal-life-game

## Goal

Build a small, dependency-free Python terminal implementation of Conway's Game of Life that demonstrates how a harness task workspace captures scope, implementation, checks, and handoff evidence.

## Project

`example-product`

## Scope

- Create a pure Python terminal app under `repo/life.py`.
- Support deterministic sample seeds and random boards.
- Provide a non-interactive mode suitable for automated smoke checks.
- Add unit tests for core simulation rules.
- Add a repo-local `scripts/check.sh` quality gate.

## Non-goals

- No curses dependency.
- No third-party packages.
- No graphical UI.
- No persistent save/load format beyond built-in seed choices.

## Done Criteria

- [x] Game of Life rules implemented and tested.
- [x] CLI supports dimensions, seed selection, steps, FPS, density, and wrap/no-wrap behavior.
- [x] Check script passes from a clean shell.
- [x] Task findings and progress are documented.
- [x] Example remains safe for a public repository.
