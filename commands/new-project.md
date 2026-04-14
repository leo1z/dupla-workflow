Initialize project from docs. Run after nuevo-proyecto.sh creates the structure.

Usage: /new-project

---

## Pre-check

Verify these files exist. If any missing → stop and tell user:

- `docs/IDEA_DRAFT.md`
- `docs/ROADMAP.md`
- `docs/ARCHITECTURE.md`

---

## Execution

1. Read: `docs/IDEA_DRAFT.md`
2. Read: `docs/ROADMAP.md`
3. Read: `docs/ARCHITECTURE.md`
4. Read: `CLAUDE.md` (project root)
5. Initialize `docs/PROJECT_STATE.md` using PROJECT_STATE_TEMPLATE structure:
   - Current Goal: first phase from ROADMAP
   - Status: "Project initialized — ready to start Phase 1"
   - In Progress: first tasks from ROADMAP Phase 1
   - Next Steps: Must/Should/Could from ROADMAP
   - Blockers: none
   - Branch: work/setup

---

## Output (max 10 lines)

---
## Project Initialized — [name]

**Phase:** [from ROADMAP]
**First steps:**
1. [concrete — from ROADMAP Phase 1]
2. [concrete]
3. [concrete]

**State written to:** docs/PROJECT_STATE.md
**Next:** run /new-session to start working
---

## Rules

- Do NOT explore codebase (nothing built yet)
- Do NOT ask questions — trust the docs as input
- Do NOT over-specify PROJECT_STATE — keep it minimal
- PROJECT_STATE must be useful for the first /new-session
