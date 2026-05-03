# /qa — Conversational Bug Intake → Beads Tasks

Use this command to do a QA pass after shipping a feature, or to report a batch of
issues conversationally. Describe bugs and rough edges as you find them; the agent
files them as beads tasks in the background.

---

## Setup

Before the session starts, orient silently:

```bash
bd list --json | jq '[.[] | {id, title, status, priority}]'          # understand current open work
bd ready --json | jq '[.[] | {id, title, status, priority}]'         # see what's in flight
```

Read `CONTEXT.md` to use domain vocabulary in all task titles and descriptions.

If an epic ID is provided (e.g. `/qa bd-a1b2`), all filed tasks will be linked to it
as children. Otherwise tasks are filed at the top level with priority P1.

---

## The Session

Tell me: **"Describe issues as you find them — one at a time or in batches. I'll file them as we go."**

Then listen. For each issue I describe:

### 1. Clarify (if needed)

Ask at most one clarifying question before filing. The goal is fast capture, not a
full requirements session. If something needs more detail, note it on the task.

Unclear: "the button doesn't work"
→ Ask: "Which button and what happens when you click it?"

Clear: "submitting the checkout form with an empty cart throws a 500"
→ File immediately, no clarification needed.

### 2. Explore the codebase

Silently look for context that will help triage the issue:
- Relevant module or file
- Whether a similar bug was fixed before (`git log --oneline --grep="<term>"`)
- Whether there's an existing open task for this (`bd list --json | jq '[.[] | {id, title, status, priority}]' | grep "<term>"`)

### 3. File in beads

```bash
# Create the task
ISSUE=$(bd create "<concise title in domain language>" \
  -t bug \
  -p <priority> \
  $( [[ -n "$EPIC" ]] && echo "--parent $EPIC" ) \
  --json | jq -r '.id')

# Add reproduction and context
bd update $ISSUE --description "$(cat <<'EOF'
**Reported**: <what the user said>
**Reproduction**: <steps or context from codebase exploration>
**Suspected area**: <file or module if known>
EOF
)"
```

**Priority guide**:
- P0: crashes, data loss, broken core flows
- P1: wrong behavior in normal use
- P2: polish, edge cases, nice-to-haves

### 4. Confirm and continue

Report back: `"Filed <id>: <title> (P<n>). What's next?"`

---

## Deduplication

Before filing, check for duplicates:
```bash
bd list --json | jq '[.[] | select(.status == "open") | {id, title, status, priority}]'
```

If a clear duplicate exists, note it and skip filing (or `bd dep add` a relates_to link):
```bash
bd dep add <new-id> <existing-id>   # use relates_to relationship
```

---

## Closing the Session

When the QA pass is done, summarise:

```
## QA Session Summary

**Filed (<count> tasks)**:
- <id> P<n>: <title>
- ...

**Duplicates skipped**: <count> (linked to existing tasks)

**Suggested priority order**:
1. <id>: <title> — <one-line reason>
2. ...

Run `bd ready --json | jq '[.[] | {id, title, status, priority}]'` to see which are immediately workable.
```
