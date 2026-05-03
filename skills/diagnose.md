# /diagnose [task-id?] — Debug a Bug or Performance Regression

Use this command when something is broken and you don't know why. It runs a disciplined
reproduce → minimise → hypothesise → instrument → fix → regression-test loop.

If you have a beads task ID for the bug, provide it. If not, one will be created.

---

## Phase 0: Track the Bug

If a task ID was provided, read it:
```bash
bd show <id> --json
```

If no ID was provided, create one now:
```bash
BUG=$(bd create "<brief bug description>" -t bug -p 0 --json | jq -r '.id')
bd update $BUG --claim
```

Read `CONTEXT.md` if it exists. Use domain vocabulary throughout — in hypotheses,
in test names, in commit messages.

---

## Phase 1: Reproduce

**Goal**: a deterministic, local reproduction. Do not proceed until you have one.

- Find or write the shortest path to trigger the failure (a test, a script, a command)
- Run it. Confirm it fails consistently.
- If you cannot reproduce it, stop and update the beads task:
  ```bash
  bd update $BUG --notes "Cannot reproduce locally. Steps tried: <list>. Needs: <what's missing>"
  ```
  Then report back and ask for help.

Once reproduced, record the reproduction steps on the task:
```bash
bd update $BUG --notes "Reproduced via: <command or test>"
```

---

## Phase 2: Minimise

Reduce the reproduction to the smallest possible case:

- Strip away unrelated code paths, config, data
- Binary search: comment out half the suspects, see if it still fails
- The minimum reproduction is your test case in Phase 6

Do not skip this. Debugging the full system is slower than debugging the minimal case.

---

## Phase 3: Hypothesise

Form **at most three** hypotheses, ranked by likelihood. For each:

- State what you believe is wrong and why
- State what evidence would confirm or refute it
- Do NOT investigate all three in parallel — pick the most likely one first

Write them on the task:
```bash
bd update $BUG --notes "Hypotheses:
1. [most likely] <hypothesis> — confirms if: <signal>
2. <hypothesis> — confirms if: <signal>
3. <hypothesis> — confirms if: <signal>
Investigating #1 first."
```

---

## Phase 4: Instrument

Add targeted observability to test hypothesis #1:

- Logs, assertions, temporary debug prints — whatever gives signal fastest
- Do NOT refactor while debugging. Do NOT fix other things you notice.
- Run the minimal reproduction. Does the signal confirm or refute the hypothesis?

If **confirmed**: move to Phase 5.
If **refuted**: move to hypothesis #2. Update the task notes.
If **inconclusive**: add more instrumentation or refine the hypothesis.

---

## Phase 5: Fix

With the root cause confirmed, write the fix:

- Fix only what caused the bug. Scope creep during a debug session produces new bugs.
- If you spot other problems while fixing, create new beads tasks for them:
  ```bash
  bd create "<other problem noticed>" -t bug -p 2 --json
  ```
- Remove all debug instrumentation before committing.

Verify the minimal reproduction now passes.

---

## Phase 6: Regression Test

Write a test that would have caught this bug:

- It must be RED before your fix and GREEN after
- Test through the public interface — not the internal implementation that was wrong
- Name it after the domain concept involved, not the implementation detail:
  - Good: `"order checkout fails when cart is empty"`
  - Bad: `"validateCartItems returns false for empty array"`
- Add the test ID or file to the beads task notes

If this bug area lacks test infrastructure, file a task for it:
```bash
bd create "Add test coverage for <area>" -t task -p 2 --parent <epic-id-if-known> --json
```

---

## Phase 7: Close and Commit

Remove debug code, run the full test suite, then:

```bash
git add -A
git commit -m "Fix <bug description> ($BUG)"

bd close $BUG "Fixed: <one sentence root cause and solution>"
```

Report back:
- Root cause (in domain language)
- What the fix was
- What the regression test covers
- Any follow-up tasks filed
