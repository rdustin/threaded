# /work [task-id?] — Claim, Implement, and Close a Beads Task

Use this command to execute a single unit of work tracked in beads. Provide a task ID
to work a specific task, or omit it to auto-select the best ready task.

Implementation defaults to TDD (red → green → refactor). For bug tasks, use
`/diagnose` instead — it has a dedicated debugging loop.

---

## Phase 1: Select a Task

**If a task ID was provided**, verify it exists and is not already claimed:
```bash
bd show <id> --json
```

**If no task ID was provided**, find the best ready task:
```bash
bd ready --json
```

Pick the highest-priority unblocked task. If multiple tie on priority, prefer the one
that unblocks the most downstream work (`bd dep list --json`).

Present the selected task and ask: **"Should I work on `<id>: <title>`? Or specify a different one."**

Do not proceed until confirmed.

---

## Phase 2: Claim and Orient

```bash
bd update <id> --claim
```

Then orient:

1. Read the full task: `bd show <id> --json`
2. Check its dependencies: `bd dep list <id> --json`
3. Read `CONTEXT.md` — use domain vocabulary in variable names, test names, and commit messages.
4. **If the area is unfamiliar**, zoom out before diving in:
   > Go up a layer of abstraction. Give me a map of all the relevant modules and callers, using the domain vocabulary in `CONTEXT.md`.
5. Explore the codebase purposefully. Don't read everything; navigate to what matters.

Briefly state your understanding before starting:
```
Working on <id>: <title>
Approach: <2-3 sentences>
Files likely touched: <list>
Behaviors to test: <list>
```

Get confirmation if the approach is non-obvious.

---

## Phase 3: Plan the Tests

Before writing any code, confirm:

- What is the **public interface** that callers use? (This is the test surface — not internals.)
- Which **behaviors** matter most? (Observable outcomes, not implementation steps.)
- Are there **deep module** opportunities? (Complex logic that could sit behind a simple, stable interface?)

List the behaviors to test in priority order, then get approval. You can't test everything — focus on critical paths and domain logic.

---

## Phase 4: Implement (Red → Green → Refactor)

Work one behavior at a time. **Never write all tests first, then all code** — that's horizontal slicing and produces tests that test shape, not behavior.

### Each cycle:

**RED** — Write one failing test for the next behavior:
- Describes behavior, not implementation
- Tests through the public interface only
- Would survive an internal refactor unchanged
- Is currently FAILING ✓

**GREEN** — Write minimal code to pass it:
- Only enough for this test — nothing speculative
- Is now PASSING ✓

**REFACTOR** — Clean up while green:
- Extract duplication
- Deepen modules (hide complexity behind simpler interfaces)
- Rename using domain vocabulary from `CONTEXT.md`
- **Never refactor while RED**

Repeat for the next behavior.

### Anti-patterns to avoid

- **Horizontal slicing**: writing all tests, then all code. The tests end up testing imagined behavior.
- **Implementation testing**: mocking internal collaborators, testing private methods, asserting on database state. Tests should survive refactors.
- **Speculative code**: writing things the current test doesn't need yet.

### If you hit a mystery bug mid-task

Stop, file a blocker, switch to `/diagnose`:
```bash
BLOCKER=$(bd create "Bug: <description>" -t bug -p 0 --json | jq -r '.id')
bd dep add <current-id> $BLOCKER
```
Report back: "Found a blocking bug — filed `$BLOCKER`. Run `/diagnose $BLOCKER` to fix it first."

### If you notice scope creep

File it, don't do it now:
```bash
bd create "<related work>" -t task -p 2 --parent <epic-id> --json
```

---

## Phase 5: Verify

Before closing:

1. Run the full test suite (or relevant subset)
2. Re-read the acceptance criteria from `bd show <id>` — does the implementation satisfy them?
3. Check domain vocabulary is used consistently in new code and test names
4. Remove debug prints, TODOs, and commented-out code

Do not close with failing tests.

---

## Phase 6: Close and Handoff

```bash
git add -A
git commit -m "<description of change> (<task-id>)"

bd close <id> "<one-sentence summary of what was done>"
```

Then:
```bash
bd ready --json
```

Report:
- What was completed
- Which tasks are now unblocked
- Suggested next: `"Next up: /work <next-id>"`

If this was the last task under an epic, check and close it:
```bash
bd show <epic-id> --json
# if all children closed:
bd close <epic-id> "All tasks complete"
```
