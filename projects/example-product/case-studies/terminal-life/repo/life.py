#!/usr/bin/env python3
"""Terminal Conway's Game of Life.

A small, dependency-free example used by the Harness Workspace public case study.
"""

from __future__ import annotations

import argparse
import random
import sys
import time
from dataclasses import dataclass
from typing import Iterable, Sequence

Cell = tuple[int, int]
Board = set[Cell]


@dataclass(frozen=True)
class LifeConfig:
    """Runtime configuration for a Life simulation."""

    width: int = 40
    height: int = 20
    steps: int = 100
    fps: float = 10.0
    seed: str = "glider"
    density: float = 0.25
    wrap: bool = True
    clear_screen: bool = True


def normalize_cell(cell: Cell, width: int, height: int) -> Cell:
    """Wrap a cell into the board bounds."""

    x, y = cell
    return (x % width, y % height)


def in_bounds(cell: Cell, width: int, height: int) -> bool:
    """Return whether a cell is inside the board bounds."""

    x, y = cell
    return 0 <= x < width and 0 <= y < height


def neighbors(cell: Cell, width: int, height: int, *, wrap: bool) -> Iterable[Cell]:
    """Yield the neighboring cells for a cell."""

    x, y = cell
    for dy in (-1, 0, 1):
        for dx in (-1, 0, 1):
            if dx == 0 and dy == 0:
                continue
            candidate = (x + dx, y + dy)
            if wrap:
                yield normalize_cell(candidate, width, height)
            elif in_bounds(candidate, width, height):
                yield candidate


def step(board: Board, width: int, height: int, *, wrap: bool = True) -> Board:
    """Advance a board by one generation."""

    candidates: set[Cell] = set(board)
    for cell in board:
        candidates.update(neighbors(cell, width, height, wrap=wrap))

    next_board: Board = set()
    for cell in candidates:
        live_neighbors = sum(1 for neighbor in neighbors(cell, width, height, wrap=wrap) if neighbor in board)
        if cell in board and live_neighbors in (2, 3):
            next_board.add(cell)
        elif cell not in board and live_neighbors == 3:
            next_board.add(cell)
    return next_board


def translate(pattern: Sequence[Cell], offset_x: int, offset_y: int, width: int, height: int) -> Board:
    """Move a pattern onto the board, wrapping into bounds."""

    return {normalize_cell((x + offset_x, y + offset_y), width, height) for x, y in pattern}


def centered(pattern: Sequence[Cell], width: int, height: int) -> Board:
    """Place a pattern near the center of the board."""

    max_x = max(x for x, _ in pattern)
    max_y = max(y for _, y in pattern)
    return translate(pattern, (width - max_x - 1) // 2, (height - max_y - 1) // 2, width, height)


def seeded_board(seed: str, width: int, height: int, density: float) -> Board:
    """Create an initial board from a named seed."""

    seed = seed.lower()
    patterns: dict[str, Sequence[Cell]] = {
        "glider": [(1, 0), (2, 1), (0, 2), (1, 2), (2, 2)],
        "blinker": [(0, 1), (1, 1), (2, 1)],
        "block": [(0, 0), (1, 0), (0, 1), (1, 1)],
        "toad": [(1, 1), (2, 1), (3, 1), (0, 2), (1, 2), (2, 2)],
        "beacon": [(0, 0), (1, 0), (0, 1), (3, 2), (2, 3), (3, 3)],
    }
    if seed == "random":
        rng = random.Random()
        return {
            (x, y)
            for y in range(height)
            for x in range(width)
            if rng.random() < density
        }
    if seed not in patterns:
        choices = ", ".join(sorted([*patterns.keys(), "random"]))
        raise ValueError(f"unknown seed '{seed}'. Choose one of: {choices}")
    return centered(patterns[seed], width, height)


def render(board: Board, width: int, height: int, generation: int) -> str:
    """Render a board as terminal text."""

    lines = [f"Generation {generation} | live cells: {len(board)}"]
    border = "+" + "-" * width + "+"
    lines.append(border)
    for y in range(height):
        row = "".join("█" if (x, y) in board else " " for x in range(width))
        lines.append(f"|{row}|")
    lines.append(border)
    return "\n".join(lines)


def run(config: LifeConfig) -> None:
    """Run the terminal simulation."""

    board = seeded_board(config.seed, config.width, config.height, config.density)
    delay = 0 if config.fps <= 0 else 1 / config.fps
    for generation in range(config.steps + 1):
        if config.clear_screen:
            sys.stdout.write("\033[2J\033[H")
        sys.stdout.write(render(board, config.width, config.height, generation) + "\n")
        sys.stdout.flush()
        if generation < config.steps:
            board = step(board, config.width, config.height, wrap=config.wrap)
            if delay:
                time.sleep(delay)


def positive_int(value: str) -> int:
    parsed = int(value)
    if parsed <= 0:
        raise argparse.ArgumentTypeError("must be positive")
    return parsed


def bounded_density(value: str) -> float:
    parsed = float(value)
    if not 0 <= parsed <= 1:
        raise argparse.ArgumentTypeError("must be between 0 and 1")
    return parsed


def parse_args(argv: Sequence[str] | None = None) -> LifeConfig:
    parser = argparse.ArgumentParser(description="Run Conway's Game of Life in the terminal.")
    parser.add_argument("--width", type=positive_int, default=40)
    parser.add_argument("--height", type=positive_int, default=20)
    parser.add_argument("--steps", type=int, default=100, help="number of generations to render")
    parser.add_argument("--fps", type=float, default=10.0, help="frames per second; use 0 for no delay")
    parser.add_argument("--seed", default="glider", help="glider, blinker, block, toad, beacon, or random")
    parser.add_argument("--density", type=bounded_density, default=0.25, help="random seed density")
    parser.add_argument("--no-wrap", action="store_true", help="disable edge wrapping")
    parser.add_argument("--no-clear", action="store_true", help="do not clear the terminal between frames")
    args = parser.parse_args(argv)
    if args.steps < 0:
        parser.error("--steps must be zero or greater")
    if args.fps < 0:
        parser.error("--fps must be zero or greater")
    return LifeConfig(
        width=args.width,
        height=args.height,
        steps=args.steps,
        fps=args.fps,
        seed=args.seed,
        density=args.density,
        wrap=not args.no_wrap,
        clear_screen=not args.no_clear,
    )


def main(argv: Sequence[str] | None = None) -> int:
    try:
        config = parse_args(argv)
        run(config)
        return 0
    except KeyboardInterrupt:
        return 130
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
