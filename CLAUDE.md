# CLAUDE.md — Agent Orientation for `threaded` Contributors

Read `BOOTSTRAP.md` first. It is the authoritative source for what this repo is,
why it exists, and how the commands relate to each other.

Then read `CONTEXT.md` for domain vocabulary. Use those terms everywhere — in edits,
commit messages, and task titles.

## Quick facts

- Skills live in `skills/*.md`. Users install by copying to their project's `.claude/commands/`.
- The 7 commands are: `/plan`, `/work`, `/diagnose`, `/qa`, `/refactor`, `/improve-arch`, `/land`.
- beads (`bd`) is the task persistence layer. Every command reads from or writes to it.

## Hard constraints

- Do not add a feature without running a grilling session (`/plan`) first.
- Every skill must leave the user's codebase in a green, committed state when it exits.
- Scope creep is filed as a beads task, never done mid-command.
- All new domain terms go into `CONTEXT.md` immediately — not at the end of a session.
