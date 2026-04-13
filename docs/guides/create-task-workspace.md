# Create a Task Workspace

Task workspaces isolate feature/fix/release work.

Recommended path:

```text
projects/<project>/active/<task-id>/
```

Each task workspace should contain:

```text
task.md       # purpose, scope, affected repos, PR links
progress.md   # chronological work log
findings.md   # discoveries and decisions
<repo-clones>/
```

## Lifecycle

1. Create task directory under `active/`.
2. Clone the required repos into that directory.
3. Create feature/fix branches according to the project profile.
4. Record PRs and status in `projects/<project>/tasks.yml`.
5. When done, move the task to `archived/YYYY-MM/` or delete it if it has no lasting value.
