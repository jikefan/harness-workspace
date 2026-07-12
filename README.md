# Harness Workspace

A lightweight workspace template for working with AI coding agents across multiple repositories.

The goal is simple: keep baseline checkouts clean, do all implementation work in isolated `git worktree` directories, and give agents a predictable place for temporary notes, scripts, and long-lived documentation.

## Directory Layout

```text
.
├── AGENTS.md                 # Instructions for Codex, Cursor, and other agents
├── CLAUDE.md                 # Same workspace contract, optimized for Claude Code
├── docs/                     # Durable notes and project documentation
├── projects/
│   └── <workspace>/
│       ├── repos/            # Baseline repositories. Pull only.
│       ├── staging/          # Optional staging/develop worktrees. Pull only.
│       └── worktrees/        # Feature branches and PR work.
├── scratch/                  # Disposable task artifacts. Ignored by git.
└── tools/                    # Workspace helper scripts
```

## Quick Start

Clone this template:

```bash
git clone https://github.com/jikefan/harness-workspace.git
cd harness-workspace
```

Register a repository:

```bash
tools/register-repo.sh my-work github.com:owner/app.git
```

Create a feature worktree:

```bash
tools/new-worktree.sh feat-login-polish app staging my-work
cd projects/my-work/worktrees/feat-login-polish/app
```

Create a short-lived scratch area:

```bash
mkdir -p "scratch/$(date +%F)-debug-login"
```

## Core Rules

1. Treat `projects/<workspace>/repos/` as read-only baseline checkouts.
2. Treat `projects/<workspace>/staging/` as read-only shared branch worktrees.
3. Make code changes only in `projects/<workspace>/worktrees/<branch>/<repo>/`.
4. Put temporary investigation files under `scratch/`.
5. Put durable project knowledge under `docs/`.
6. Do not commit secrets, `.env` files, local tokens, screenshots with private data, or customer/project-specific internal notes.

## Tools

- `tools/register-repo.sh <workspace> <repo-url> [repo-name]` clones a baseline repository.
- `tools/add-shared-worktree.sh <workspace> <repo> <branch>` creates a read-only shared branch worktree, such as `staging` or `develop`.
- `tools/new-worktree.sh <branch> <repo> [base] [workspace]` creates an isolated implementation worktree.
- `tools/pull-baselines.sh [workspace]` updates baseline and shared worktrees.
- `tools/check-branch-status.sh <workspace> <repo> [base]` shows ahead/behind status for local branches.
- `tools/clean-worktrees.sh [workspace]` interactively removes merged local worktrees.

## GitHub

This repository is intentionally generic. Fork it, clone it, or use it as a template for your own agent workspace. Project-specific documents and credentials should live in private repositories or local-only ignored directories.
