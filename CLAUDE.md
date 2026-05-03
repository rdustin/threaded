# CLAUDE.md — Agent Orientation for `threaded` Contributors

Read `BOOTSTRAP.md` first. It is the authoritative source for what this repo is,
why it exists, and how the commands relate to each other.

Then read `CONTEXT.md` for domain vocabulary. Use those terms everywhere — in edits,
commit messages, and task titles.

## Quick facts

- Skills live in `skills/*.md`. Users install by copying to their project's `.claude/commands/`.
- The 9 commands are: `/context`, `/plan`, `/work`, `/diagnose`, `/qa`, `/refactor`, `/improve-arch`, `/land`, `/caveman`.
- beads (`bd`) is the task persistence layer. Every command reads from or writes to it.

## Hard constraints

- Run `/context` before `/plan` on new projects or when `CONTEXT.md` is stale — domain vocabulary must exist before planning begins.
- Do not add a feature without running a grilling session (`/plan`) first.
- Every skill must leave the user's codebase in a green, committed state when it exits.
- Scope creep is filed as a beads task, never done mid-command.
- All new domain terms go into `CONTEXT.md` immediately — not at the end of a session.


<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
