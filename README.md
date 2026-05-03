# threaded

**Skills for deliberate AI-assisted development.**

Most AI coding sessions drift. You start with a clear goal and end with a pile of half-done work, broken tests, and a codebase that's harder to understand than when you started. This happens because the agent is optimising for momentum, not alignment.

threaded is a set of Claude Code slash commands that impose structure on that process. It keeps you and the agent aligned before and during implementation, tracks work so sessions can resume cleanly, and pushes back when scope creeps or the approach is wrong.

The name: beads on a thread — individual tasks, in order, connected.

---

## Built on two upstream projects

**[beads](https://github.com/gastownhall/beads)** is a lightweight CLI task tracker designed for Claude Code sessions. It replaces the mental overhead of "what was I doing?" with a persistent, structured task list the agent can read and write. Every threaded command produces and consumes beads tasks. Install it first.

**[mattpocock/skills](https://github.com/mattpocock/skills)** is a set of Claude Code slash commands built around deliberate engineering practices: grilling sessions, TDD loops, disciplined debugging, and architecture review. threaded adapts the philosophy and several specific skills from this repo, replacing their GitHub issue output with beads tasks.

---

## The 9 commands

| Command | Phase | What it does |
|---|---|---|
| `/th:plan` | Planning | Grill session to resolve alignment → beads epic + tasks with dependency wiring |
| `/th:work` | Execution | Claim a task, implement with TDD (red → green → refactor), close it |
| `/th:diagnose` | Execution | Debug a bug: reproduce → minimise → fix → regression test |
| `/th:qa` | Quality | Conversational bug intake → beads tasks |
| `/th:refactor` | Maintenance | Plan a refactor as tiny safe commits → beads tasks |
| `/th:improve-arch` | Maintenance | Find shallow modules and architecture friction → beads refactor epic |
| `/th:land` | Wrap-up | Close tasks, push, write session handoff |
| `/th:context` | Utility | Build or review `CONTEXT.md` domain vocabulary |
| `/th:caveman` | Utility | Switch Claude to ultra-compressed output mode |

---

## Installation

### Global (preferred)

Clone this repo somewhere permanent, then run the install script:

```bash
git clone https://github.com/your-org/threaded ~/skills/threaded
cd ~/skills/threaded
./install.sh
```

This symlinks every skill into `~/.claude/commands/th/`. Because they are symlinks,
`git pull` in this directory updates all your installed skills automatically — no
re-install needed.

### Project-level

Copy individual skills into your project:

```bash
cp skills/th/plan.md .claude/commands/th/plan.md
cp skills/th/work.md .claude/commands/th/work.md
```

### Prerequisite

You also need [beads](https://github.com/gastownhall/beads) installed:

```bash
# see beads repo for installation
bd --version
```

---

## Quick start

A typical session looks like this:

```
/th:context    → define domain vocabulary (new projects, or when CONTEXT.md is stale)
/th:plan       → agree on what to build; loads an epic + tasks into beads
/th:work       → implement one task at a time with TDD
/th:diagnose   → if a bug blocks progress mid-task
/th:qa         → after shipping a feature, capture issues
/th:land       → close out, push, leave a handoff note for the next session
```

Run these periodically to keep the architecture healthy:

```
/th:improve-arch  → surfaces refactor opportunities as beads tasks
/th:refactor      → when a specific refactor is identified; plans a safe commit sequence
```

---

## Key design decisions

**beads is the single source of truth for work.** No task lives only in your head or in a comment. Any session can resume from `bd ready` without losing context.

**TDD is the default, not an option.** `/th:work` runs red → green → refactor for every task. Horizontal slicing (all tests first, then all code) is explicitly an anti-pattern.

**Scope creep is filed, not done.** Every command has a standard pattern: if something related-but-not-in-scope is noticed, file a beads task and continue. Nothing is done opportunistically mid-task.

**Domain language is non-negotiable.** Every command reads `CONTEXT.md` before doing anything. Test names, variable names, commit messages, and task titles all use domain vocabulary.

**Commands are composable.** Adopt just `/th:plan` and `/th:work` if that's all you need. There is no required ceremony. Each command is a standalone file you can read and understand in two minutes.

---

## License

MIT
