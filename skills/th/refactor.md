# /th:refactor — Plan a Refactor as Tiny Safe Commits → Beads Tasks

Use this when you want to clean up or restructure existing code. It interviews you
about the change, designs a sequence of tiny commits that each leave the codebase
green, then files that sequence as beads tasks.

This is the safe alternative to "just refactor it" — each step is independently
reviewable and reversible.

---

## Phase 1: Orient

Read silently:
- `CONTEXT.md` — domain vocabulary
- `docs/adr/` — relevant past decisions
- `bd list --json | jq '[.[] | {id, title, status, priority}]'` — check if related work is already tracked

---

## Phase 2: Understand the Goal

Ask me, one question at a time:

1. **What's the problem with the current code?** (What makes it hard to change, test, or understand?)
2. **What does the ideal end state look like?** (In terms of module shape, testability, or domain alignment — not file names)
3. **What can't change?** (Public interfaces that callers depend on, behavior that must be preserved, ADRs we must respect)
4. **How big is the blast radius?** (Which callers/tests would be affected?)
5. **Is there a safe order?** (What can be done without touching callers first?)

For each question, provide your recommended answer based on codebase exploration.

---

## Phase 3: Design the Commit Sequence

A safe refactor is a sequence of commits where **every commit leaves tests green**.

Common patterns:

```
# Pattern A: Introduce → Migrate → Delete
1. Add new interface alongside old one (no callers changed)
2. Migrate callers one by one (old interface still exists)
3. Delete old interface (all callers migrated)

# Pattern B: Extract → Inline
1. Extract logic into a new deep module (tests still pass)
2. Replace inline logic in callers with the new module

# Pattern C: Rename via alias
1. Add alias with new name pointing to old
2. Update callers to new name
3. Remove alias and old name
```

Design the specific sequence for this refactor. Each step should be:
- **One commit** — small enough to review in 5 minutes
- **Green** — tests pass after this commit alone
- **Reversible** — could be reverted without taking the other steps with it

Present the sequence:
```
Step 1: <what changes> — <why it's safe>
Step 2: <what changes> — <why it's safe>
...
```

Ask: **"Does this sequence make sense? Should any steps be split or merged?"**

---

## Phase 4: File in Beads

Once confirmed:

```bash
# Create the refactor epic
EPIC=$(bd create "Refactor: <goal in domain language>" \
  -t epic -p 2 --json | jq -r '.id')

# One task per commit step
T1=$(bd create "Step 1: <description>" \
  -t task -p 2 --parent $EPIC --json | jq -r '.id')
T2=$(bd create "Step 2: <description>" \
  -t task -p 2 --parent $EPIC --json | jq -r '.id')
# ...

# Steps are strictly ordered
bd dep add $T2 $T1
bd dep add $T3 $T2
# ...

# Add detail to each step
bd update $T1 --design "$(cat <<'EOF'
Files touched: <list>
What changes: <description>
Tests that should stay green: <which ones>
Commit message: "refactor: <description> ($T1)"
EOF
)"
```

Report:
- Epic ID and all step task IDs
- First step is immediately workable: `"Start with /th:work <T1>"`
- Estimated total steps and rough size

---

## Constraints

- Every step must leave the test suite green. If a step can't, split it.
- Do not mix refactor commits with behavior changes. If a refactor reveals a bug, file a separate bug task.
- Commit messages should start with `refactor:` and include the beads task ID.
