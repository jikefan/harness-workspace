#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
import re
import shutil
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Archive a completed harness task by updating tasks.yml and moving its workspace."
    )
    parser.add_argument("project", help="Project id, e.g. t46")
    parser.add_argument("task_id", help="Task id to archive")
    parser.add_argument(
        "--root",
        help="Harness repo root. Defaults to auto-detected root from this script location.",
    )
    return parser.parse_args()


def detect_root(explicit_root: str | None) -> Path:
    if explicit_root:
        return Path(explicit_root).resolve()
    return Path(__file__).resolve().parents[2]


def load_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines(keepends=True)


def save_lines(path: Path, lines: list[str]) -> None:
    path.write_text("".join(lines), encoding="utf-8")


def find_task_block(lines: list[str], task_id: str) -> tuple[int, int]:
    start = None
    pattern = f"  - id: {task_id}"
    for idx, line in enumerate(lines):
        if line.rstrip("\n") == pattern:
            start = idx
            break
    if start is None:
        raise SystemExit(f"Task id not found in registry: {task_id}")

    end = len(lines)
    for idx in range(start + 1, len(lines)):
        if lines[idx].startswith("  - id: "):
            end = idx
            break
    return start, end


def archive_paths(project: str, task_id: str) -> tuple[str, str]:
    year_month = dt.date.today().strftime("%Y-%m")
    active = f"projects/{project}/active/{task_id}"
    archived = f"projects/{project}/archived/{year_month}/{task_id}"
    return active, archived


def rewrite_block(block: list[str], project: str, task_id: str) -> list[str]:
    today = dt.date.today().isoformat()
    active_rel, archived_rel = archive_paths(project, task_id)
    archived_prefix = f"{archived_rel}/"
    active_prefix = f"{active_rel}/"
    completion_note = f'      - "Completed and archived on {today}."\n'

    rewritten: list[str] = []
    notes_index: int | None = None
    has_completion_note = False

    for line in block:
        if re.match(r"^    status:\s+", line):
            rewritten.append("    status: archived\n")
            continue
        if re.match(r'^    updated_at:\s+"[^"]*"\s*$', line):
            rewritten.append(f'    updated_at: "{today}"\n')
            continue
        if re.match(r"^    workspace:\s+", line):
            rewritten.append(f"    workspace: {archived_rel}\n")
            continue
        if re.match(r"^        path:\s+", line):
            rewritten.append(line.replace(active_prefix, archived_prefix))
            continue
        if active_rel in line:
            line = line.replace(active_rel, archived_rel)
        if "Completed and archived on " in line:
            has_completion_note = True
        if line.rstrip("\n") == "    notes:":
            notes_index = len(rewritten)
        rewritten.append(line)

    if has_completion_note:
        return rewritten

    if notes_index is not None:
        insert_at = notes_index + 1
        while insert_at < len(rewritten) and rewritten[insert_at].startswith("      - "):
            insert_at += 1
        rewritten.insert(insert_at, completion_note)
        return rewritten

    if rewritten and not rewritten[-1].endswith("\n"):
        rewritten[-1] += "\n"
    rewritten.extend(["    notes:\n", completion_note])
    return rewritten


def update_registry(root: Path, project: str, task_id: str) -> tuple[Path, str, str]:
    tasks_path = root / "projects" / project / "tasks.yml"
    if not tasks_path.exists():
        raise SystemExit(f"Task registry not found: {tasks_path}")

    lines = load_lines(tasks_path)
    start, end = find_task_block(lines, task_id)
    block = lines[start:end]
    rewritten = rewrite_block(block, project, task_id)
    lines[start:end] = rewritten
    save_lines(tasks_path, lines)

    active_rel, archived_rel = archive_paths(project, task_id)
    return tasks_path, active_rel, archived_rel


def move_workspace(root: Path, active_rel: str, archived_rel: str) -> tuple[Path, Path]:
    active_path = root / active_rel
    archived_path = root / archived_rel
    archived_path.parent.mkdir(parents=True, exist_ok=True)

    if archived_path.exists() and not active_path.exists():
        return active_path, archived_path

    if not active_path.exists():
        raise SystemExit(f"Active workspace does not exist: {active_path}")

    shutil.move(str(active_path), str(archived_path.parent))
    return active_path, archived_path


def main() -> int:
    args = parse_args()
    root = detect_root(args.root)

    tasks_path, active_rel, archived_rel = update_registry(root, args.project, args.task_id)
    active_path, archived_path = move_workspace(root, active_rel, archived_rel)

    print(f"Updated registry: {tasks_path}")
    print(f"Archived task: {args.project}/{args.task_id}")
    print(f"From: {active_path}")
    print(f"To:   {archived_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
