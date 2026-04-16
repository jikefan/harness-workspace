# Harness Repo-Local Skills

This directory is reserved for repo-local Codex skills that should be
auto-discoverable when working inside `T46-harness-workspace`.

Current policy:

- keep only real harness-level skills here
- do not put project-specific business skills here by default
- prefer storing project-specific skill source files outside this directory, then
  syncing or linking them into target repositories when needed

Current harness-level skills:

- `harness-archive-task` — archive completed task workspaces and sync `tasks.yml`
