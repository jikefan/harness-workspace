# Harness Workspace Agent Rules

This workspace manages agentic coding workflows across multiple projects. It is a harness project: rules, profiles, tools, templates, task registries, and artifacts live here; business code lives in project task workspaces.

## Highest Priority Rules

- Do not edit business project code directly on `main` / default production branches.
- Use project profiles under `profiles/<project>/` before working on a project.
- Create task workspaces under `projects/<project>/active/<task>/`.
- Store generated reports, logs, screenshots, and exports under `artifacts/`.
- Store disposable scratch files under `tmp/`.
- Never put secrets in `AGENTS.md`, docs, templates, committed configs, or task registry files.
- Production write/destructive operations require explicit user confirmation.
- Prefer executable checks over prose-only rules. If a repo has `scripts/agent/check.sh`, run it before PR/hand-off.

## Where to Look First

- Harness overview: `README.md`
- Workspace layout: `docs/harness/workspace-layout.md`
- Security policy: `docs/harness/security-policy.md`
- Project profile design: `docs/harness/project-profile-design.md`
- Task workflow: `docs/guides/create-task-workspace.md`
- Project-specific rules: `profiles/<project>/AGENTS.md`
- Tool entrypoint: `tools/harness`

## Tooling Convention

Use the unified harness entrypoint when available:

```bash
tools/harness audit
tools/harness task-status <project>
tools/harness repo-status <project>
tools/harness branch-status <project>
```

If a tool is project-specific, it should live under `tools/profiles/<project>/` and be referenced by `profiles/<project>/tools.yml`.
