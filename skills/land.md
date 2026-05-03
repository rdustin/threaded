# /land — Close Out a Session

Use this command when you're done for the session and want to leave the repo in a clean, resumable state. Wraps up code, beads, and context — and leaves a clear "pick up here" note.

**The session is NOT landed until `git push` succeeds. Never stop before that.**

---

## Step 1: File Remaining Work

For anything discovered during this session that wasn't done, file beads tasks now:
```bash
bd create "<unfinished thing>" -t task -p <priority> --parent <epic-id> --json
```

Don't leave things only in your head or in comments.

---

## Step 2: Quality Gates

Run these only if code was changed this session:

```bash
# Adapt these to the project's actual test/lint commands
# e.g. for a typical JS/TS project:
# npm test
# npm run lint

# e.g. for Go:
# make test
# golangci-lint run ./...
```

If quality gates are failing, file a P0 beads task and note it in the session summary. **Do not close issues if tests are red.**

---

## Step 3: Update Beads

Close tasks that were completed this session:
```bash
bd close <id> "<reason>" --json
```

Update status on in-progress tasks:
```bash
bd update <id> --notes "Session ended mid-task. Next step: <what to do>"
```

If an entire epic is done, close it too:
```bash
bd close <epic-id> "All child tasks complete"
```

---

## Step 4: Push — MANDATORY

```bash
# Pull first
git pull --rebase

# Push all code changes
git push

# Verify
git status   # must show "up to date with origin/main"
```

**Do not skip this step. Do not say "ready to push when you are." Push it.**

---

## Step 5: Clean Up

```bash
git stash clear
git remote prune origin
```

---

## Step 6: Session Summary

Report the following:

```
## Session Summary

**Completed this session:**
- <task-id>: <what was done>
- ...

**Filed for follow-up:**
- <task-id>: <what needs doing>
- ...

**Quality gates:** ✅ passing / ⚠️ <issue filed: task-id>

**Pushed to remote:** ✅ confirmed

**Recommended next session prompt:**
"Continue work on <task-id>: <title>. <1-2 sentences of context about where we left off and what's next.>"
```

---

## Step 7: Choose a Next Task (optional)

```bash
bd ready --json | jq '[.[] | {id, title, status, priority}]'
```

Suggest the best next task for the following session.
