# BOOTSTRAP.md — Claude Code Orientation for `threaded`

Read this file first. Then read every file in `.claude/commands/`. Then ask questions
before writing anything.

---

## What This Repo Is

**threaded** is a set of Claude Code slash commands that bring deliberate, structured
engineering workflow to AI-assisted development. It is not a framework. It is not
opinionated about your stack. It is a small, composable set of commands you run
during development sessions to stay aligned, ship incrementally, and avoid the
entropy that agents accelerate.

The name comes from the image of beads on a thread: individual tasks, in order,
connected.

**Tagline**: _Skills for deliberate AI-assisted development, built on beads._

---

## The Two Upstream Projects

### [beads](https://github.com/gastownhall/beads)

beads is a lightweight CLI task tracker designed for Claude Code sessions. It gives
agents a way to claim, track, and close tasks without a heavyweight issue tracker.
Key commands:

- `bd create` — create a task or epic
- `bd ready` — list unblocked tasks ready to work
- `bd update <id> --claim` — claim a task for this session
- `bd close <id>` — mark a task done
- `bd dep add <id> <blocks-id>` — declare a dependency between tasks

All threaded commands produce and consume beads tasks. beads is the persistence layer.

### [mattpocock/skills](https://github.com/mattpocock/skills)

Matt Pocock's skills repo is a set of Claude Code slash commands built around
deliberate engineering practices: grilling sessions to resolve alignment before
coding, TDD loops, disciplined debugging, and architecture review. threaded adapts
the philosophy and several specific skills from this repo, replacing their GitHub
issue output with beads tasks.

Key concepts carried over:
- `CONTEXT.md` — a living domain glossary that agents read before every session
- ADRs in `docs/adr/` — hard architectural decisions so agents don't re-litigate them
- Grilling — asking questions one at a time before committing to an approach
- Vertical slices / tracer bullets — one behavior tested and implemented at a time
- Deep modules — hide complexity behind simple interfaces; test through public interfaces only

---

## The 8 Commands

All commands live in `skills/`. Install them by copying to your project's
`.claude/commands/` directory, or to `~/.claude/commands/` for global use.

| Command | Phase | Purpose |
|---|---|---|
| `/plan` | Planning | Grill session → beads epic + tasks with dependency wiring |
| `/work [id?]` | Execution | Claim a task, implement with TDD, close it |
| `/diagnose [id?]` | Execution | Debug a bug: reproduce → minimise → fix → regression test |
| `/qa` | Quality | Conversational bug intake → beads tasks |
| `/refactor` | Maintenance | Plan a refactor as tiny safe commits → beads tasks |
| `/improve-arch` | Maintenance | Find architecture problems → beads refactor epic |
| `/land` | Wrap-up | Close tasks, push, write session handoff |
| `/caveman` | Utility | Switch Claude to ultra-compressed output mode |

### Typical session flow

```
/plan          → agree on what to build, load into beads
/work          → implement one task at a time (TDD by default)
/diagnose      → if a bug blocks progress mid-task
/qa            → after shipping a feature, capture issues
/land          → close out, push, leave handoff for next session
```

### Periodic maintenance

```
/improve-arch  → every few days; surfaces refactor opportunities as beads tasks
/refactor      → when a specific refactor is identified; plans safe commit sequence
```

---

## Key Design Decisions

**beads is the single source of truth for work.**
No task exists outside beads. Every command either reads from or writes to beads.
Planning output goes into beads. Bug reports go into beads. Architecture findings
go into beads. This means any session can resume from `bd ready` without losing context.

**TDD is the default, not an option.**
`/work` runs red → green → refactor for every task. Horizontal slicing (all tests
first, then all code) is explicitly called out as an anti-pattern. Tests are written
against public interfaces, not internals.

**Scope creep is filed, not done.**
Every command has a standard pattern: if something related-but-not-in-scope is
noticed, `bd create` it and continue. Nothing is done opportunistically mid-task.

**Domain language is non-negotiable.**
Every command reads `CONTEXT.md` before doing anything. Test names, variable names,
commit messages, and beads task titles all use domain vocabulary. If a new term
emerges during a session, `CONTEXT.md` is updated inline.

**Commands are composable, not a framework.**
A team can adopt just `/plan` and `/work`. Or just `/diagnose`. There is no
required ceremony. Each command is a standalone file that can be read and understood
in two minutes.

**Token efficiency is a first-class concern.**
`bd list` and `bd ready` are piped through `jq` to return only `id`, `title`, `status`, and `priority` — the full JSON payload is never dumped raw. For output, `/caveman` switches Claude into ultra-compressed mode, cutting response tokens ~75% while keeping full technical accuracy.

---

## Repo Structure

```
.
├── BOOTSTRAP.md          ← you are here
├── CLAUDE.md             ← agent orientation for contributors
├── CONTEXT.md            ← domain glossary for this repo itself
├── LICENSE
├── README.md
└── skills/
    ├── plan.md
    ├── work.md
    ├── diagnose.md
    ├── qa.md
    ├── refactor.md
    ├── improve-arch.md
    ├── land.md
    └── caveman.md
```

---

## CONTEXT.md for This Repo

The domain terms used in this repo itself (for agents working on threaded):

- **command** — a single `.md` file in `.claude/commands/` that Claude Code exposes
  as a slash command
- **phase** — one of: Planning, Execution, Quality, Maintenance, Wrap-up
- **task** — a unit of work tracked in beads (type: task or bug)
- **epic** — a parent grouping of tasks in beads (type: epic)
- **upstream** — either gastownhall/beads or mattpocock/skills
- **beads task** — a task tracked via the `bd` CLI
- **TDD loop** — red → green → refactor cycle within `/work`
- **grilling** — asking one question at a time to resolve alignment before committing
  to an approach
- **domain vocabulary** — the terms defined in a project's `CONTEXT.md`
- **vertical slice** — one behavior, tested and implemented end-to-end before moving
  to the next
- **deep module** — a module with a simple interface hiding complex implementation

---

## What to Create

Based on this bootstrap, create the following. Ask me questions before writing each one.

1. **README.md** — public-facing, explains the project to newcomers. Should cover:
   what it is, why it exists (deliberate vs vibe coding), the two upstream projects
   briefly with links, the 7 commands and their purpose, installation instructions,
   and a quick-start workflow example. Tone: direct and opinionated, similar to
   mattpocock/skills README.

2. **CONTEXT.md** — the domain glossary for this repo (draft from the terms in this
   file, ask me to add or remove any).

3. **LICENSE** — ask me which license before creating.

Do not create anything else without asking first.
