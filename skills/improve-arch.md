# /improve-arch — Find Architecture Problems → Beads Refactor Epic

Run this every few days, or whenever a codebase area has been growing fast. It finds
"deepening opportunities" — places where shallow modules can be consolidated into deep
ones — and files them as a beads epic with child tasks.

It does NOT make changes. It produces a prioritised list, you pick what to pursue,
then those become tasks you can run `/work` on.

---

## Vocabulary

Use these terms consistently. Don't drift into "service," "component," "boundary," or "API layer."

- **Module** — anything with an interface and an implementation (function, class, package, file)
- **Interface** — everything a caller must know: types, invariants, error modes, ordering, config
- **Depth** — leverage: a lot of behaviour behind a small interface. **Deep** = high leverage
- **Shallow** — interface nearly as complex as the implementation; a pass-through
- **Seam** — where an interface lives; where behaviour can be altered without editing in place
- **Locality** — change, bugs, and knowledge concentrated in one place

**Deletion test**: imagine deleting the module. If complexity vanishes, it was a pass-through (shallow). If complexity reappears across N callers, it was earning its keep (deep).

---

## Phase 1: Orient

Read silently:
- `CONTEXT.md` — domain vocabulary that names good seams
- `docs/adr/` — decisions not to re-litigate
- Recent git log: `git log --oneline -20` — which areas have been active?
- Current open beads work: `bd list --json | jq '[.[] | {id, title, status, priority}]'` — avoid proposing what's already planned

---

## Phase 2: Explore

Walk the codebase organically. Note where you experience friction:

- Where does understanding one concept require bouncing between many small files?
- Where are modules **shallow** — the interface is nearly as complex as what's inside?
- Where do you find pure functions extracted just for testability, but the real bugs live in how they're called? (No locality)
- Which areas are untested, or only testable by reaching into internals?
- Where do tightly-coupled modules leak across their seams?

Apply the **deletion test** to candidates: "If I deleted this and inlined it into its callers, would complexity concentrate or spread?"

Concentrate = deep, worth keeping or deepening further.
Spread = shallow, could be merged into a caller or consolidated.

---

## Phase 3: Present Candidates

Present a numbered list. For each candidate:

```
### <N>. <Name using CONTEXT.md vocabulary>

**Files**: <which files/modules are involved>
**Problem**: <why this causes friction — in terms of depth, locality, or testability>
**Solution**: <plain English: what would change>
**Benefit**: <what gets better — test coverage, locality, AI-navigability>
**ADR conflict**: <if any — mark clearly and explain why it's worth revisiting>
```

Use `CONTEXT.md` domain vocabulary for the domain concepts, and the glossary above for architecture concepts. Don't mix them.

Ask: **"Which of these would you like to pursue? I'll file them as beads tasks."**

Do NOT propose specific interfaces yet. Do NOT make any code changes.

---

## Phase 4: Grilling Loop (for chosen candidates)

For each candidate the user picks, drop into a brief grilling conversation:

- What sits behind the seam?
- Which callers change, which stay the same?
- What's the simplest interface that covers the real use cases?
- What tests would survive this refactor? Which tests would need to be rewritten?
- Does this introduce a new domain term? (If so, it goes in `CONTEXT.md`.)

If the user **rejects** a candidate with a load-bearing reason, offer an ADR:
> "Want me to record this as an ADR so future architecture reviews don't re-suggest it?"
> Only offer when the reason would actually help a future reviewer.

---

## Phase 5: File in Beads

Once candidates are agreed:

```bash
# Create the refactor epic
EPIC=$(bd create "Refactor: <theme>" -t epic -p 2 --json | jq -r '.id')

# One task per candidate
T1=$(bd create "Deepen <module name>: <one-line goal>" \
  -t task -p 2 --parent $EPIC \
  --json | jq -r '.id')

# Add design notes to each task
bd update $T1 --design "$(cat <<'EOF'
Problem: <friction description>
Solution: <plain English>
Interface sketch: <rough API if discussed>
Tests to write: <behaviors to verify>
EOF
)"

# Wire dependencies if order matters
bd dep add $T2 $T1   # T2 should come after T1
```

After filing:
```bash
bd show $EPIC --json
```

Report:
- The epic ID and all task IDs
- Which are immediately workable (`bd ready --json | jq '[.[] | {id, title, status, priority}]'`)
- Suggested order: "Start with `<id>` — it unblocks the most and has the clearest interface."

---

## Notes on Scope

- **Do not** touch code during this command. Exploration only.
- **Do not** re-litigate an ADR unless friction is severe — mark it clearly if you do.
- **Do not** file more than 5–7 tasks per run. Prioritise ruthlessly; a long list is noise.
- If `CONTEXT.md` needs a new term from this session, update it before finishing.
