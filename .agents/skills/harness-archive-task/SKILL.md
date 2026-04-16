---
name: harness-archive-task
description: Archive completed harness task workspaces in T46-harness-workspace. Use when the user asks to mark a task complete, update `projects/<project>/tasks.yml`, move a task from `projects/<project>/active/<task-id>` to `projects/<project>/archived/YYYY-MM/<task-id>`, or clean up unregistered temporary task directories after completion.
---

# Harness Archive Task

Use this skill for harness-level task closure, not for business-code changes.

## Scope

This skill applies when working inside `T46-harness-workspace` and the user wants to:

- mark one or more tasks as complete
- update the harness task registry
- move completed task workspaces into `archived/YYYY-MM/`
- delete temporary task directories that were never registered

Do not use this skill for project-specific business logic or repository code changes.

## Workflow

### 1. Confirm the target tasks

Identify:

- project id, e.g. `t46`
- registered task ids from `projects/<project>/tasks.yml`
- unregistered temporary directories under `projects/<project>/active/`

Preferred command:

```bash
tools/harness archive-task <project> <task-id>
```

If the command is unavailable or a task needs special handling, fall back to the manual checks below.

Useful checks:

```bash
tools/harness task-status <project>
sed -n '1,220p' projects/<project>/tasks.yml
find projects/<project>/active -maxdepth 1 -mindepth 1 -type d | sort
```

### 2. Prefer the harness command

Run:

```bash
tools/harness archive-task <project> <task-id>
```

This command updates `tasks.yml`, rewrites task paths, creates `archived/YYYY-MM/` if needed, and moves the workspace.

### 3. Update the registry first when handling it manually

For registered completed tasks:

- set `status: archived`
- set `updated_at` to the current date
- change `workspace` from `projects/<project>/active/<task-id>` to `projects/<project>/archived/YYYY-MM/<task-id>`
- update any repo paths under `repos.*.path` to the archived location
- fix notes if they still point at the old active path

Use `apply_patch` for registry edits.

### 4. Move the workspace

Create the archive bucket if needed:

```bash
mkdir -p projects/<project>/archived/YYYY-MM
```

Then move the task directory:

```bash
mv projects/<project>/active/<task-id> projects/<project>/archived/YYYY-MM/
```

### 5. Clean temporary directories only when explicitly requested

If a directory under `active/` is not registered in `tasks.yml`, treat it as disposable scratch.

Only delete it when the user explicitly asks to clean it up.

Typical examples:

- one-off production query folders
- analysis notes not meant for retention
- aborted planning directories

### 6. Verify and report

After moving or deleting:

- rerun `tools/harness task-status <project>`
- list `projects/<project>/active/`
- list the target `projects/<project>/archived/YYYY-MM/`

The final report should say:

- which tasks were archived
- which directories were deleted
- what active tasks remain

## Rules

- Never archive a task directory without updating `tasks.yml`.
- Never delete a registered task workspace unless the user explicitly asks.
- Never delete archived work by default.
- Keep the registry and filesystem consistent in the same turn.
- If only the registry is updated but the move fails, fix the mismatch before finishing.

## Fast Checklist

- registry status updated
- workspace path updated
- repo paths updated
- directory moved or deleted
- active list rechecked
- archived list rechecked
