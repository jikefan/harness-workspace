```text
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║   ██╗  ██╗ █████╗ ██████╗ ███╗   ██╗███████╗███████╗███████╗       ║
║   ██║  ██║██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝██╔════╝       ║
║   ███████║███████║██████╔╝██╔██╗ ██║█████╗  ███████╗███████╗       ║
║   ██╔══██║██╔══██║██╔══██╗██║╚██╗██║██╔══╝  ╚════██║╚════██║       ║
║   ██║  ██║██║  ██║██║  ██║██║ ╚████║███████╗███████║███████║       ║
║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝       ║
║                                                                      ║
║                    W O R K S P A C E   F O R                       ║
║              A G E N T I C   E N G I N E E R I N G                 ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

# Harness Workspace

> An agentic engineering workspace for AI coding agents: turning context, rules, tasks, tools, and evidence into a reusable local operating system for software delivery.

Prefer Chinese? Read the [中文版本](README.zh-CN.md).

`Harness Workspace` is not a business application repository. It is a project-agnostic operating layer for multi-project, multi-repository, human-and-agent software engineering workflows. It helps convert ad-hoc conversational development into a traceable, auditable, portable, and reusable engineering system.

The core idea is simple: AI coding agents become more reliable when they work inside explicit boundaries — project profiles, task workspaces, quality gates, safety policies, and executable tools.

## Vision

In complex software delivery, the scarce resource is not a single code-generation attempt. The scarce resource is durable engineering context:

- Where are the project rules?
- Which directories are safe to commit, and which must remain local?
- What should an agent read, run, and verify before acting?
- How should multi-repository tasks be split, tracked, archived, and reviewed?
- Where should generated reports, screenshots, logs, and exports live?
- How can private customer or project data be kept out of public repositories by default?

This repository provides a reusable answer: a neutral harness foundation where real projects plug in through profiles, while the public repository keeps only generic rules, anonymized examples, templates, and safe tooling.

## What This Workspace Provides

- **Agent instruction hub** — `AGENTS.md` defines the top-level operating contract for coding agents.
- **Project profiles** — `profiles/<project>/` describes project-specific rules, repositories, environments, and tools.
- **Task lifecycle structure** — `projects/<project>/active|archived|scratch/` organizes task work from kickoff to handoff.
- **Unified tool entrypoint** — `tools/harness` exposes audit, task-status, repo-status, and project-specific tool routing.
- **Open-source safety defaults** — real project profiles, task workspaces, generated artifacts, caches, and common secret patterns are ignored by default.
- **Reusable templates** — `templates/` provides scaffolds for project profiles, tasks, and repo-local agent harness files.
- **Evidence-first delivery** — checks, reports, findings, and task progress are encouraged as durable artifacts rather than informal claims.

## Repository Layout

```text
AGENTS.md                 # Root rules for agents: boundaries, protocols, safety constraints
docs/                     # Harness concepts and operational guides
profiles/                 # Project profiles; public repo keeps anonymized examples only
projects/                 # Task registries and workspaces; real project work is local by default
templates/                # Reusable profile, task, and repo harness templates
tools/                    # Executable tools and the unified harness entrypoint
artifacts/                # Generated reports, logs, screenshots, exports; ignored except README
tmp/                      # Disposable scratch files; ignored except README
```

## Quick Start

```bash
# Audit the harness workspace structure
tools/harness audit

# Inspect the anonymized example task registry
tools/harness task-status example-product

# Inspect repositories under an example project workspace
tools/harness repo-status example-product
```

To onboard a new project profile:

```bash
cp -R templates/profile profiles/<project-id>
```

Then fill in:

- `profiles/<project-id>/AGENTS.md` — project-specific agent rules
- `profiles/<project-id>/profile.yml` — project metadata and runtime conventions
- `profiles/<project-id>/repos.yml` — repository inventory
- `profiles/<project-id>/environments.yml` — environment entrypoints and safety notes, never secrets
- `profiles/<project-id>/tools.yml` — project-specific tool index

## Workflow Model

### 1. Rules before execution

Before touching a real project, agents should read the root `AGENTS.md` and the relevant project profile. Rules are not decoration; they are the first safety layer for preventing accidental edits, destructive operations, and unreviewable work.

### 2. Task workspaces before business-code edits

Business repository clones should not be scattered at the harness root. Use task-scoped workspaces:

```text
projects/<project>/active/<task-id>/<repo-clone>
```

Archive completed task work under:

```text
projects/<project>/archived/YYYY-MM/<task-id>
```

Place experiments under:

```text
projects/<project>/scratch/<experiment>
```

### 3. Verification before completion claims

Prefer executable checks over prose-only rules. If a repository provides an agent check script, run it before handoff:

```bash
scripts/agent/check.sh
```

If no repo-local check exists, use the commands documented in the project profile. Completion reports should include what was actually verified.

## Open-source Safety Model

This workspace is designed to be publishable, provided the `.gitignore` safety boundary is respected.

Ignored by default:

- real project profiles
- real task registries
- cloned business-code workspaces
- generated reports, screenshots, logs, CSVs, database dumps
- local caches, runtime state, `.omx/`
- `.env`, certificates, private keys, tokens, passwords, and common credential patterns

Safe to publish:

- generic documentation
- anonymized examples
- reusable templates
- safe command wrappers
- public-safe conventions with no customer data or internal paths

## Design Principles

- **Explicit boundaries** — business code, task artifacts, temporary files, and durable docs live in different places.
- **Secure by default** — private context stays local unless deliberately scrubbed and reviewed.
- **Tools over folklore** — rules that can be checked should become scripts.
- **Portable by design** — profiles let the same harness support multiple projects.
- **Auditable by habit** — task progress, findings, and validation evidence should be structured.
- **Human-agent collaboration** — humans, AI agents, CI, and operational tools share the same working contract.

## Good Use Cases

- multi-repository product engineering
- long-running AI coding agent workflows
- project rule and tooling standardization
- task-scoped worktree or clone management
- separating private project context from public templates
- standardizing code review, release checks, and operational reports

## Roadmap

- stronger structured checks in `tools/harness`
- profile initialization scaffolding
- task archive and report generation commands
- best-practice templates for repo-local `scripts/agent/check.sh`
- stricter public-repository sensitive-content scanning

## License

This project is open sourced under the [MIT License](LICENSE).
