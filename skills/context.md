# /context — Build and Maintain Domain Vocabulary

Run this command before `/plan` on a new project, or whenever `CONTEXT.md` feels stale. It interviews you to produce a precise domain glossary that every other threaded command reads before acting.

No beads integration — this command produces one output: a committed `CONTEXT.md`.

---

## Phase 1: Orient

Read silently:
- `README.md` (if exists) — project purpose and key concepts
- `CONTEXT.md` (if exists) — determines mode: create vs review
- Top-level directory and file names — surface signals for domain terms
- `docs/` (if exists) — any additional context

Determine mode:
- **Create**: no `CONTEXT.md` exists → build from scratch
- **Review**: `CONTEXT.md` exists → challenge existing terms, then find gaps

---

## Phase 2: Interview

### Create mode

Tell the user:

> "No `CONTEXT.md` found. I'll ask a few structured questions to build one. Answer for your project — I'll propose canonical terms and definitions from your answers."

Ask one question at a time in this order. For each answer: propose a canonical term and one-line definition, get confirmation, write to `CONTEXT.md` immediately, then move on.

**Core nouns** — the things your system works with:
> "What are the main things your system creates, stores, or operates on?"
> *(e.g. for a billing app: invoice, subscription, payment)*

**Key actions** — what happens to those things:
> "What are the key operations in your domain — what do users or the system do to these things?"
> *(e.g. charge, cancel, refund)*

**Relationships** — how terms connect:
> "Are there important relationships between the terms we've defined that have a specific name in your domain?"
> *(e.g. a subscription has many invoices)*

**Jargon check** — internal shorthand:
> "Is there language your team uses internally that an outsider wouldn't recognise? Abbreviations, shorthand, or loaded terms?"

When exhausted, ask: **"Any other terms to lock in before we start planning?"**

### Review mode

Tell the user:

> "I found an existing `CONTEXT.md`. I'll go through each term to check accuracy, then look for gaps."

Go term by term:
> "Is `<term>` still accurate? Current definition: `<definition>`. Still used this way?"

- **Yes** → move on
- **No** → propose updated definition → confirm → overwrite in `CONTEXT.md` immediately

After all existing terms are reviewed, shift to gaps:
> "Any concepts you've been using recently that aren't captured here?"

Same propose → confirm → write pattern for new terms.

---

## Phase 3: Commit

Once the session is complete:

```bash
git add CONTEXT.md
git commit -m "docs: update CONTEXT.md with domain vocabulary"
```

Report: **"`CONTEXT.md` is up to date with `<n>` terms. Ready to run `/plan`."**
