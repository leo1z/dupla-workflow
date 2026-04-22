---
doc: CLAUDE
type: Semi-static
updated: YYYY-MM-DD
purpose: Project-specific instructions and constraints
project_type: team
---

# Context — [PROJECT_NAME]

## Project

[1–2 lines — what it does and for whom]

---

## Current Phase

[Planning / Prototype / MVP / Production]

---

## Stack (High-Level)

- Tech 1
- Tech 2
- Tech 3

---

## Team

**Leader:** [Name] — approves PRs, merges to main, updates Shared Status
**Members:**
- [Dev A Name] — [Role: Backend/Frontend/DB/etc] — work/[phase]-[role]
- [Dev B Name] — [Role] — work/[phase]-[role]
- [Dev C Name] — [Role] — work/[phase]-[role]

**Edit roles:** run `/add-team-member` or manually update this section

---

## Git Strategy

```
main                    ← production (leader merges here)
├─ work/phase1-backend  ← Dev A
├─ work/phase1-frontend ← Dev B
└─ work/phase1-db       ← Dev C
```

**Branch naming:** `work/[phase]-[role]` (e.g. `work/phase1-api`)
**Dev workflow:**
1. Work on your branch
2. `/checkpoint` → auto-updates your section in PROJECT_STATE from git log
3. Push to `work/[your-branch]`
4. Leader reviews → `/checkpoint approve-pr [branch]` → merges to main

**Merge order** (follow ROADMAP dependencies):
1. [Dev C] DB first (others depend on schema)
2. [Dev A] Backend (uses DB)
3. [Dev B] Frontend (uses API)

---

## Constraints

- Do NOT push to main directly (leader only)
- No credentials in repo
- Each dev edits ONLY their section in PROJECT_STATE.md
- [specific gotchas or non-obvious rules]

---

## Workflow Rules

- PROJECT_STATE.md + code = source of truth
- `/new-session` tells you your branch + what to do next
- `/checkpoint` auto-generates Done from your git log
- Leader runs `/checkpoint approve-pr` to review and merge
- Adapt if reality changes — roles are editable

---

## Command Map

- /new-session → reads your Dev section + dependencies (~60 tokens)
- /checkpoint → save + auto-update your status from git log
- /checkpoint approve-pr [branch] → leader reviews + merges
- /add-team-member → add new dev to project
- /restore → revert to numbered save point

---

## Docs Map

- Team state → docs/PROJECT_STATE.md (## Team Status)
- Phase plan → docs/ROADMAP.md (## Role Assignments per phase)
- Architecture → docs/ARCHITECTURE.md
- Problems → docs/PROBLEMS.md

---

## References

→ Global behavior: ~/.claude/CLAUDE.md
→ Active projects: ~/.claude/SYSTEM.md
→ Problems across projects: ~/.claude/PROBLEMS_GLOBAL.md
→ Credentials: ~/.claude/CREDENTIALS.md (reference only, never commit)
