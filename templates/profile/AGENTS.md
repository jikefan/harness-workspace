# <Project Name> Agent Rules

## Git

- Never modify the default production branch directly.
- Use feature or fix branches for code changes.

## Runtime

- Document project-specific runtime requirements here.

## Safety

- Production write or destructive operations require explicit user confirmation.
- Keep secrets out of docs, templates, and task registry files.

## Quality

- Prefer repo-local `scripts/agent/check.sh` when available.
- Add project-specific engineering checks here.

## Complex Domain Changes

When a task touches stateful, cross-entity business changes, read:

- `docs/rules/README.md`
- `prompts/complex-domain-change.txt`

Additional project-specific constraints should be listed here.
