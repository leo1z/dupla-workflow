Adopt an existing project into the dupla-workflow system.

Usage: /adopt

Run this when opening an existing project that doesn't follow the workflow yet.

---

## Phase 1 — Scan (silent, no output yet)

Read what exists:
1. Run: `git log --oneline -10`, `git branch --show-current`, `git status --short`
2. Read: CLAUDE.md (root) if exists
3. Read: README.md if exists
4. Read: package.json / requirements.txt / go.mod (whatever exists)
5. List: docs/ folder contents
6. Check which workflow docs exist:
   - [ ] docs/PROJECT_STATE.md
   - [ ] docs/PROBLEMS.md
   - [ ] docs/ROADMAP.md
   - [ ] docs/ARCHITECTURE.md
   - [ ] CLAUDE.md (in correct format)

---

## Phase 2 — Report gaps

Show a clear checklist before doing anything:

---
## Adopt Report — [project name]

**Found:**
- [list what exists]

**Missing:**
- [list what's needed]

**CLAUDE.md:** [matches template / needs update / doesn't exist]

Proceed? [s/n]
---

Wait for confirmation.

---

## Phase 3 — Generate missing docs

Generate ONLY what's missing. Use real info from the code — do NOT use empty templates.

### docs/PROJECT_STATE.md (if missing)
Infer from: git log (recent activity), existing CLAUDE.md, README.
Fill all fields from PROJECT_STATE_TEMPLATE. Use current git branch as active branch.
Mark items in Next Steps as Must/Should/Could based on git log + any open TODOs found.

### docs/ARCHITECTURE.md (if missing)
Infer from: folder structure, package.json deps, README, existing CLAUDE.md.
Follow ARCHITECTURE.md template structure. Mark what was inferred vs what needs review.

### docs/PROBLEMS.md (if missing)
Create from template — empty, ready to use.

### docs/ROADMAP.md (if missing)
Do NOT invent a roadmap. Instead:
- Create placeholder from template
- Add note: "PENDING — fill using templates/PLAN_PROMPT.md or manually"

### CLAUDE.md update (if exists but wrong format)
Show diff of what would change.
Wait for approval before writing.

### CLAUDE.md create (if doesn't exist)
Generate from CLAUDE_TEMPLATE.md using real project info.

---

## Phase 4 — Register project

Add project to ~/.claude/PROJECTS_SKILLS.md:
- Read current PROJECTS_SKILLS.md
- Add new row: project name, path, GitHub (from git remote), current phase (from PROJECT_STATE)
- Write updated file

---

## Output (max 15 lines)

---
## Project Adopted — [name]

**Created:**
- [list of files created]

**Updated:**
- [list of files updated]

**Inferred (review recommended):**
- [anything Claude guessed — user should verify]

**Registered in:** ~/.claude/PROJECTS_SKILLS.md

**Next:** run /new-session to start working
---

## Rules

- NEVER overwrite existing docs without showing diff + approval
- Prefer partial over empty — fill what you can from real code
- Mark clearly what was inferred vs confirmed
- If git log is empty → note that state inference is limited
