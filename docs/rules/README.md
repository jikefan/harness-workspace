# Generic Engineering Rules

These rules are for cross-project engineering concerns that appear in many
business systems, especially when one user action updates multiple entities or
tables.

They are not naming or formatting guides. They are meant to reduce:

- state inconsistency
- domain-boundary drift
- accidental parallel write paths
- review decisions based only on "it works"

Read these when a change touches stateful, cross-entity logic:

1. `complex-domain-engineering.md`
2. `complex-state-pr-review.md`
3. `../../prompts/complex-domain-change.txt`

If a project has stricter domain-specific rules, add them under
`profiles/<project>/docs/rules/` and reference them from that profile's
`AGENTS.md`.
