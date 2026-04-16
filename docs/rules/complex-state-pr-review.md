# Complex State PR Review

## Purpose

This checklist is for pull requests that touch stateful, cross-entity business
logic. Its job is to catch high-cost issues before approval:

- inconsistent state
- domain ownership drift
- duplicated write paths
- changes that make future work harder

## Review Order

Before checking whether the feature "works", review these first:

1. Did this change add or widen a write path?
2. Did it weaken state consistency?
3. Did it increase long-term maintenance cost?

## Stop-Ship Conditions

Any of these should block approval:

- a second write path was introduced for an existing business fact
- core state was modified outside the owner domain
- private service methods are being used as formal business boundaries
- correctness depends on callers performing follow-up updates
- one business action is split across multiple transactions or callers
- new compatibility logic was added without a removal condition
- there is no invariant test, only branch or endpoint coverage

## Review Questions

### 1. Is the domain owner clear?

Ask:

- who decides this business fact?
- did this PR bypass the owner and patch state directly?
- can multiple modules still decide the same fact?

### 2. Did writes converge into one path?

Ask:

- did the change reuse an existing command?
- or did it copy similar logic into another module?
- after this PR, does the same action now have multiple implementations?

### 3. Is state consistency complete?

Ask:

- can related entities end up half-updated?
- if the action fails, is the system left in a broken partial state?
- are linked fields updated together?

### 4. Is the transaction boundary correct?

Ask:

- how many records or tables are updated?
- are those updates inside one business transaction?
- do side effects run only after core state is stable?

### 5. Is compatibility logic controlled?

Ask:

- is the change converging logic or adding another compatibility branch?
- is there a clear removal condition?
- is the new path becoming the formal path?

### 6. Does the change improve future extensibility?

Ask:

- will the next feature copy this logic again?
- did the abstraction reduce cognitive load?
- can a neighboring action reuse the same command?

### 7. Do tests protect invariants?

Minimum bar:

- at least one invariant test

Good tests prove that related entities remain consistent after success, retry,
rollback, or idempotent re-entry.

## Review Comment Templates

### Added write path

```text
This change introduces a new write path outside the current domain owner. That
is likely to drift from the existing logic over time. Please route the behavior
through the existing command, or first converge the command boundary and then
attach the feature.
```

### Caller must do one more step

```text
This implementation depends on the caller performing a follow-up update to keep
the final state consistent. That is fragile. Please move the linked updates
into one business action owned by a single entrypoint.
```

### Compatibility logic is growing

```text
This adds another compatibility branch without a removal condition. It may work
short term, but it raises long-term maintenance cost. Please clarify the
relationship between the old and new paths and define how the compatibility path
will be removed.
```

### Missing invariant test

```text
The current tests mainly cover branch behavior, but they do not protect the
core invariant. Please add a test showing that the related records remain
consistent after this action.
```
