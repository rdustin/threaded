# /plan — Align, Specify, and Load into Beads

Use this command when you want to plan a new feature, fix, or change. It runs a structured alignment session, then writes the output directly into beads as an Epic with child tasks.

---

## Phase 1: Orient

Before asking anything, do the following silently:

1. Run `bd list --json | jq '[.[] | {id, title, status, priority}]'` to understand current open work and epics.
2. If `CONTEXT.md` exists at the repo root, read it for domain language.
3. If `docs/adr/` exists, scan for relevant decisions.
4. Run `git log --oneline -10` to understand recent activity.

---

## Phase 2: Grill Session

Interview me relentlessly about the plan until every major decision branch is resolved. Ask one question at a time, wait for my answer, then continue.

For each question, provide your recommended answer based on what you know about the codebase.

### What to probe

**Scope & goals**
- What problem does this solve? For whom?
- What does success look like — how will we know it's done?
- What is explicitly out of scope?

**Domain language**
- When I use a term that doesn't match `CONTEXT.md`, challenge me immediately. Propose a canonical term.
- When I use vague language ("handle", "manage", "process"), ask me to be precise.

**Implementation shape**
- Which modules/areas of the codebase does this touch?
- Are there deep modules we should extract that can be tested in isolation?
- What are the dependencies between the pieces of work?

**Risk & unknowns**
- What is the riskiest assumption we're making?
- Is there anything we need to spike/explore before we can commit to this approach?

**Testing**
- What makes this correct? What would a test verify?
- Are there edge cases that need explicit coverage?

### During the session

When a term is resolved, update `CONTEXT.md` immediately — don't batch.

Only offer an ADR when all three hold:
1. Hard to reverse
2. Surprising without context
3. The result of a real trade-off

---

## Phase 3: Confirm the Plan

Once the grilling is complete, produce a concise plan summary:

```
## Plan: <title>

**Problem**: <one sentence>
**Solution**: <one sentence>
**Out of scope**: <bullet list>

### Work items (proposed)
1. <Epic title>
   - <task 1> [blocks: none]
   - <task 2> [blocks: task 1]
   - <task 3> [blocks: task 1]
   ...

### Open questions / spikes needed
- <any remaining unknowns>
```

Ask me: **"Does this plan look right? Should I load it into beads?"**

Do not proceed until I confirm.

---

## Phase 4: Load into Beads

Once confirmed, create the beads hierarchy. Use the priority I specify (default P1 for planned work, P0 for urgent fixes).

```bash
# 1. Create the epic
EPIC=$(bd create "<Epic title>" -t epic -p <priority> --json | jq -r '.id')

# 2. Create each task as a child of the epic
T1=$(bd create "<task 1 title>" -t task -p <priority> --parent $EPIC --json | jq -r '.id')
T2=$(bd create "<task 2 title>" -t task -p <priority> --parent $EPIC --json | jq -r '.id')
T3=$(bd create "<task 3 title>" -t task -p <priority> --parent $EPIC --json | jq -r '.id')

# 3. Wire up blocking dependencies
bd dep add $T2 $T1   # T2 is blocked by T1
bd dep add $T3 $T1   # T3 is blocked by T1

# 4. If there are spikes, create them as P0 tasks blocking dependent work
# SPIKE=$(bd create "Spike: <unknown>" -t task -p 0 --parent $EPIC --json | jq -r '.id')
# bd dep add $T2 $SPIKE
```

After loading, run:
```bash
bd show $EPIC --json
bd ready --json | jq '[.[] | {id, title, status, priority}]'
```

Report back:
- The epic ID and all task IDs
- Which tasks are immediately ready (unblocked)
- Suggested first task to start with: `"To begin, run /work $TASK_ID"`
