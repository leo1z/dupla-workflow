# Model Routing — Leo Borjas

> Purpose: Defines which LLM to use for which kind of work.
> Read automatically at the start of every /new-session.
> Version-controlled copy: dupla-workflow/MODEL_ROUTING.md

---

## Use Claude for

- Multi-file changes (more than 2 files in one task)
- Architecture decisions and system design
- Risky refactors (auth, DB, RLS, core business logic)
- Complex debugging that requires full project context
- Writing or updating structural docs (CLAUDE.md, ARCHITECTURE.md, PROJECT_STATE.md)
- Anything that depends on understanding how pieces connect across the codebase

---

## Use Gemini for

- Code review on a completed, isolated feature
- Research (libraries, APIs, alternatives, tradeoffs)
- Writing user-facing documentation or copy
- Repetitive or isolated tasks (rename variables, format files, single-file edits)
- Quick reference lookups where losing context is acceptable
- Tasks where you want a second opinion without consuming Claude context

---

## Handoff Protocol

When switching models mid-project, update the `## Session` block in `docs/PROJECT_STATE.md` before switching:

```
## Session

- **Active LLM:** [Claude / Gemini / other]
- **Last action:** [1-line summary of what was done this session]
- **Pending for next session:** [concrete next step — specific enough to resume cold]
```

**To hand off cleanly:**

1. Run `/progress` — writes SESSION block and updates PROJECT_STATE.md
2. `git push` — ensure nothing is lost
3. Tell the incoming model to read `docs/PROJECT_STATE.md` and `~/.claude/MODEL_ROUTING.md` at session start

---

## Decision Heuristic

When unsure which model to use:

- Touches multiple files OR needs project-wide context → **Claude**
- Isolated, bounded, no cross-system risk → **Gemini**
- Gemini hits a loop or keeps making the wrong call → switch to **Claude**
- Claude token budget nearly exhausted mid-task → run `/token-budget`, then hand bounded subtasks to **Gemini**

---

## Notes

- This file is read at the start of every `/new-session`
- Update this file when routing rules change (new models, new workflows)
- Do NOT auto-load CREDENCIALES.md — manual reference only
