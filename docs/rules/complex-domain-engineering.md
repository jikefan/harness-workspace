# Complex Domain Engineering

## Purpose

This document defines generic engineering rules for complex stateful business
changes. It applies when one business action affects multiple entities, records,
or tables that must remain consistent.

## Core Principle

The common failure mode is not weak syntax or missing abstraction vocabulary.
The common failure mode is local patching without strong engineering
constraints:

- logic is added near the latest bug instead of near the domain owner
- similar mutation logic is copied into another module
- compatibility paths accumulate without removal plans
- passing tests are mistaken for healthy design

Good engineering here is about ownership, write-path control, transaction
discipline, and invariant tests.

## Rules

### 1. One business fact should have one owner

Important business facts should have a single owner. If multiple services can
independently decide the same fact, the system will drift out of sync.

### 2. One business action should have one formal write entrypoint

State transitions should converge behind one command-style entrypoint. Other
modules may call that entrypoint, but they should not mutate the same state with
their own parallel logic.

### 3. Important invariants must be explicit

Important invariants should not live only in someone's head. They should be:

- documented
- implemented in one clear place
- protected by tests

### 4. Transaction boundaries should match business boundaries

If one business action updates multiple records, the action should complete
inside one explicit business transaction whenever the underlying system allows
it. Correctness should not depend on a caller remembering follow-up updates.

### 5. Reads may be distributed; writes should converge

Many modules may read a business state. Very few modules should write the core
state that defines that business fact.

### 6. Compatibility logic should be temporary

Compatibility logic is acceptable only when it is clearly marked, delegates to
the new path when possible, and has a removal condition. It must not quietly
become a second permanent architecture.

### 7. Command and query responsibilities should be separated

The command layer validates actions, applies transitions, coordinates
transactions, and orders side effects. The query layer assembles display data
and read models. Query logic should not mutate source-of-truth.

### 8. Prefer convergence over branching

If the current structure is already scattered, the preferred direction is to
converge logic into a smaller number of stable entrypoints, not to copy the
existing pattern into another module.

### 9. Tests should protect invariants, not only branches

Good tests should verify that the system remains consistent after the action,
not only that one branch was executed or one endpoint returned the expected
response.

## Warning Signs

These patterns usually indicate design drift:

- several modules directly update the same business state
- a module relies on another module's private method as a formal boundary
- correctness depends on callers remembering one more step
- a new feature adds branches but does not retire old paths
- tests only prove a response shape or single branch outcome

## Before Coding

For complex changes, answer these questions first:

1. Which invariant is being changed or protected?
2. Which domain owns that invariant?
3. Which existing command should be reused?
4. Which state must not be directly modified here?
5. Which invariant test proves the system still converges to a valid state?
