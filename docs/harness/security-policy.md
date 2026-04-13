# Security Policy

## Secrets

Do not store secrets in:

- `AGENTS.md`
- `README.md`
- `docs/`
- `templates/`
- `profiles/*.yml`
- task registry files

Use local `.env` files outside version control. Document their expected location, not their contents.

## Production Operations

- Production read-only operations may be wrapped in clearly named tools.
- Production write/destructive operations require explicit user confirmation.
- Scripts that can mutate production data must live under a clearly named path such as `prod-write-requires-confirm/`.

## Permissions

Prefer narrow command wrappers over broad permissions. A harness should expose safe commands rather than granting agents unconstrained shell access.
