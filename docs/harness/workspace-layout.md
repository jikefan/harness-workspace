# Workspace Layout

The harness workspace separates durable harness assets from volatile project work.

## Stable, versionable areas

- `AGENTS.md`: root agent rules and pointers.
- `docs/`: durable design, operational documentation, and generic engineering rules.
- `prompts/`: reusable prompt templates for repeatable high-risk tasks.
- `profiles/`: project-specific profiles.
- `tools/`: reusable harness commands and wrappers.
- `templates/`: reusable scaffolds for tasks and repos.

## Volatile areas

- `projects/<project>/active/`: active task workspaces and cloned repos.
- `projects/<project>/archived/`: completed task workspaces retained for reference.
- `projects/<project>/scratch/`: experiments and temporary project work.
- `artifacts/`: generated reports, screenshots, logs, CSVs, and exports.
- `tmp/`: short-lived scratch files.

## Rule

The root directory should stay clean. If a file is generated, it belongs in `artifacts/` or `tmp/`, not at the workspace root.
