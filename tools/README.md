# Tools

Use `tools/harness` as the main entrypoint.

Examples:

```bash
tools/harness audit
tools/harness task-status example-product
tools/harness repo-status example-product
tools/harness branch-status example-product
```

Public project-specific tools should be generic or anonymized. Real project tools are ignored by default under `tools/profiles/<project>/` unless explicitly unignored.
