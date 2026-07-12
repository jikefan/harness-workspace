# AGENTS.md

This workspace is designed for AI coding agents.

Read `CLAUDE.md` first. It contains the full workspace contract and decision tree. These quick rules apply to all agents:

- `projects/<workspace>/repos/` contains baseline repositories. Pull only; do not edit or commit there.
- `projects/<workspace>/staging/` contains optional shared branch worktrees. Pull only; do not edit or commit there.
- Code changes belong in `projects/<workspace>/worktrees/<branch>/<repo>/`.
- Temporary investigation files belong in `scratch/<YYYY-MM-DD-topic>/`.
- Durable notes belong in `docs/`.
- Do not use symlinks for important project files; copy files instead.
- Do not commit secrets, local `.env` files, tokens, private screenshots, production data, or customer-specific internal notes.

When in doubt, stop and ask which workspace, repository, and base branch should be used.
