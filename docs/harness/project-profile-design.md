# Project Profile Design

A project profile describes how the harness should work with one business/project domain.

Each profile lives at:

```text
profiles/<project>/
```

Recommended files:

```text
README.md          # human overview
AGENTS.md          # project-specific agent rules
profile.yml        # machine-readable project config
repos.yml          # repository inventory
environments.yml   # runtime/deploy/SSH environment notes
tools.yml          # project-specific tool index
docs/rules/        # project-specific engineering constraints and review guides
prompts/           # copyable prompt templates for repeated agent work
```

Profiles make the harness reusable. `example-product` is only an anonymized sample profile; real projects can be added locally without changing the core workspace structure.
