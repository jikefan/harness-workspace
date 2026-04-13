# Example Product Agent Rules

## Git

- Never modify `main` directly.
- Create feature/fix branches from the configured base branch.
- Open a pull request for review before merging.

## Runtime

- Frontend services use the configured Node.js version and package manager.
- Backend services use the configured language runtime and virtual environment.

## Safety

- Do not commit secrets.
- Production write/destructive operations require explicit user confirmation.
- Generated reports belong in `artifacts/`, not the workspace root.

## Quality

- Run repo-local checks before handoff.
- Prefer automated checks over manual inspection.
