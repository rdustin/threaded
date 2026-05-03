# CONTEXT.md — Domain Glossary for `threaded`

Read this before writing anything. Use these terms in skill names, commit messages,
beads task titles, and all communication with the user.

---

- **command** — a single `.md` file in `skills/` that Claude Code exposes as a slash command; synonymous with "skill" in this repo
- **phase** — one of: Planning, Execution, Quality, Maintenance, Wrap-up; each command belongs to a phase
- **task** — a unit of work tracked in beads; type may be `task` or `bug`
- **epic** — a parent grouping of tasks in beads; type `epic`
- **upstream** — either [gastownhall/beads](https://github.com/gastownhall/beads) or [mattpocock/skills](https://github.com/mattpocock/skills)
- **beads task** — a task tracked and persisted via the `bd` CLI
- **TDD loop** — the red → green → refactor cycle that `/work` runs for every behavior
- **grilling** — asking one question at a time to resolve alignment before committing to an approach; the core technique of `/plan`
- **domain vocabulary** — the terms defined in a project's `CONTEXT.md`; must be used in all test names, variable names, and commit messages
- **vertical slice** — one behavior, tested and implemented end-to-end before moving to the next; the unit of progress in `/work`
- **deep module** — a module with a simple interface hiding complex implementation; the architectural ideal promoted by `/improve-arch`
