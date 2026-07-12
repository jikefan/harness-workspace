# Harness Workspace

This is a generic workspace for AI-assisted software work. It keeps long-lived repository baselines separate from short-lived implementation worktrees.

## What Goes Where

| Task | Location |
| --- | --- |
| Inspect default branch code | `projects/<workspace>/repos/<repo>/` |
| Inspect a shared branch such as `staging` or `develop` | `projects/<workspace>/staging/<repo>/` |
| Make code changes for a PR | `tools/new-worktree.sh <branch> <repo> [base] [workspace]` |
| Keep temporary scripts, logs, screenshots, or one-off notes | `scratch/<YYYY-MM-DD-topic>/` |
| Keep durable project documentation | `docs/` |
| Keep reusable helper scripts | `tools/` |

## Hard Rules

1. Do not edit or commit inside `projects/<workspace>/repos/`.
2. Do not edit or commit inside `projects/<workspace>/staging/`.
3. Make implementation changes only in `projects/<workspace>/worktrees/`.
4. Do not commit secrets, `.env` files, private keys, local tokens, production data, or private customer documents.
5. Do not use symlinks for project handoff. Copy files when a file needs to live in the workspace.
6. Before pushing, fetch and check whether the remote branch has changed.
7. Do not automatically merge pull requests unless the user explicitly asks for it.

## Branch Base Guidance

Use the base branch that matches the work:

| Branch Prefix | Typical Base | Meaning |
| --- | --- | --- |
| `feat-` or `feature-` | `staging`, `develop`, or the team integration branch | New feature work |
| `fix-` | Ask or pass base explicitly | Ambiguous bug fix |
| `hotfix-` or `hot-` | `main` | Production fix |

If the base branch is unclear, ask before creating a worktree.

## Useful Commands

```bash
# Clone a baseline repository into the workspace.
tools/register-repo.sh my-work github.com:owner/app.git

# Add a shared branch worktree, for example staging or develop.
tools/add-shared-worktree.sh my-work app staging

# Create an implementation worktree.
tools/new-worktree.sh feat-my-feature app staging my-work

# Pull all baselines for a workspace.
tools/pull-baselines.sh my-work

# Check branch status.
tools/check-branch-status.sh my-work app main

# Clean merged local worktrees.
tools/clean-worktrees.sh my-work
```

## Agent Style

Prefer small, reversible changes. Read the local code before editing. Match existing project conventions. Verify with the narrowest meaningful checks, then broaden testing when the change touches shared behavior.
