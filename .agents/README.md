# Harness Agents

This directory holds Codex repo-local agent assets for the harness repository.

Use `.agents/skills/` for skills that should be auto-discoverable when Codex is
started inside the harness repository root.

Do not use this directory as a generic source-of-truth for all project skills.
Project-specific skill source files can live elsewhere and be linked or synced
into repo-local `.agents/skills/` directories when needed.
